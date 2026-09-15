#!/usr/bin/env bash
# Purplephx SESSION END hook - blocks until the configured graph or scan profile reaches terminal state.
set -uo pipefail

PHX_API_BASE="${PHX_API_BASE:-http://localhost:4250}"
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
PHX_REPO_NAME="${PHX_REPO_NAME:-$(basename "$PROJECT_DIR")}"
CONFIG_FILE="$PROJECT_DIR/.purplephx/session.env"
RUN_DIR="$PROJECT_DIR/.purplephx/session-runs"
mkdir -p "$RUN_DIR" 2>/dev/null || true

if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi

if [[ "${PHX_SESSION_END_ENABLED:-0}" != "1" ]]; then
  echo "[purplephx] SessionEnd disabled by config."
  exit 0
fi

enforcement="${PHX_SESSION_END_ENFORCEMENT:-block}"

if [[ -z "${PHX_API_TOKEN:-}" ]]; then
  echo "[purplephx] PHX_API_TOKEN not set; skipping session-end security scan."
  [[ "$enforcement" == "block" ]] && exit 1 || exit 0
fi

collect_changed_files() {
  if ! git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf '[]\n'
    return
  fi

  {
    git -C "$PROJECT_DIR" diff --name-only --diff-filter=ACMRTUXB 2>/dev/null || true
    git -C "$PROJECT_DIR" diff --cached --name-only --diff-filter=ACMRTUXB 2>/dev/null || true
    git -C "$PROJECT_DIR" ls-files --others --exclude-standard 2>/dev/null || true
  } | sort -u | jq -Rsc 'split("\n") | map(select(length > 0))'
}

changed_files_json="$(collect_changed_files 2>/dev/null || printf '[]\n')"

payload="$(jq -cn \
  --arg repo "$PHX_REPO_NAME" \
  --arg profile "${PHX_SESSION_PROFILE:-GRAPH_ONLY}" \
  --argjson files "$changed_files_json" \
  --argjson timeout "${PHX_SESSION_TIMEOUT_SECONDS:-900}" \
  --argjson poll "${PHX_SESSION_POLL_SECONDS:-10}" \
  '{repoName:$repo,profile:$profile,changedFiles:$files,changedFilesOnly:($files | length > 0),blockUntilComplete:true,timeoutSeconds:$timeout,pollSeconds:$poll}')"

resp="$(curl -sS --max-time "${PHX_SESSION_TIMEOUT_SECONDS:-900}" \
  -H "Authorization: Bearer ${PHX_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$payload" \
  "${PHX_API_BASE}/api/v1/purplephx/session/end" 2>/dev/null)" || {
  echo "[purplephx] backend unreachable; skipping session-end security scan."
  [[ "$enforcement" == "block" ]] && exit 1 || exit 0
}

ts="$(date -u +%Y%m%dT%H%M%SZ)"
printf '%s\n' "$resp" > "${RUN_DIR}/session-end-${ts}.json" 2>/dev/null || true
state="$(printf '%s\n' "$resp" | jq -r '.status // "unknown"' 2>/dev/null)"
profile="$(printf '%s\n' "$resp" | jq -r '.followUp.profile // env.PHX_SESSION_PROFILE // "GRAPH_ONLY"' 2>/dev/null)"
echo "[purplephx] session-end ${profile}: ${state}. Summary: ${RUN_DIR}/session-end-${ts}.json"
if [[ "$enforcement" == "block" && "$state" != "completed" ]]; then
  exit 1
fi
exit 0
