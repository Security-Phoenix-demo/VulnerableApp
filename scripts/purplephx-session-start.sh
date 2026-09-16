#!/usr/bin/env bash
# Purplephx SESSION START hook - re-indexes the code graph for the current repo.
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

if [[ "${PHX_SESSION_START_ENABLED:-0}" != "1" ]]; then
  echo "[purplephx] SessionStart disabled by config."
  exit 0
fi

if [[ -z "${PHX_API_TOKEN:-}" ]]; then
  echo "[purplephx] PHX_API_TOKEN not set; skipping graph re-index (set it to enable session-start indexing)."
  exit 0
fi

payload="$(jq -cn \
  --arg repo "$PHX_REPO_NAME" \
  '{repoName:$repo,profile:"GRAPH_ONLY",blockUntilComplete:true}')"

resp="$(curl -sS --max-time 12 \
  -H "Authorization: Bearer ${PHX_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$payload" \
  "${PHX_API_BASE}/api/v1/purplephx/session/start" 2>/dev/null)" || {
  echo "[purplephx] backend unreachable at ${PHX_API_BASE}; skipping graph re-index."
  exit 0
}

ts="$(date -u +%Y%m%dT%H%M%SZ)"
printf '%s\n' "$resp" > "${RUN_DIR}/session-start-${ts}.json" 2>/dev/null || true
status="$(printf '%s\n' "$resp" | jq -r '.steps[0].summary.graphStatus // .status // "UNKNOWN"' 2>/dev/null)"
echo "[purplephx] graph status for ${PHX_REPO_NAME}: ${status}. Use query_graph, get_call_chain, and get_entry_points to navigate."
exit 0
