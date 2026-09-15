#!/usr/bin/env bash
set -euo pipefail

TARGET_PROJECT="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"
CONFIG_DIR="$TARGET_PROJECT/.purplephx"
CONFIG_FILE="$CONFIG_DIR/session.env"
mkdir -p "$CONFIG_DIR"

cat <<'MENU'
Phoenix Purple session hooks are optional. Choose what this project should run:
1) No session hooks (default)
2) SessionStart only: graph re-index
3) SessionEnd only: graph feedback
4) SessionStart + SessionEnd: graph only
5) SessionStart + SessionEnd: SAST/SCA/IaC/Container
6) SessionStart + SessionEnd: SAST/SCA/IaC/Container + AI validation
7) SessionStart + SessionEnd: Hunt FAST
8) SessionStart + SessionEnd: Hunt DEEP
9) SessionStart + SessionEnd: Prometheus
MENU

read -r -p "Selection [1-9]: " choice
choice="${choice:-1}"

START=0
END=0
PROFILE=GRAPH_ONLY
ENFORCEMENT=block
case "$choice" in
  1) START=0; END=0; PROFILE=GRAPH_ONLY ;;
  2) START=1; END=0; PROFILE=GRAPH_ONLY ;;
  3) START=0; END=1; PROFILE=GRAPH_ONLY ;;
  4) START=1; END=1; PROFILE=GRAPH_ONLY ;;
  5) START=1; END=1; PROFILE=STANDARD_ASSESSMENT ;;
  6) START=1; END=1; PROFILE=AI_VALIDATION ;;
  7) START=1; END=1; PROFILE=HUNT_FAST ;;
  8) START=1; END=1; PROFILE=HUNT_DEEP ;;
  9) START=1; END=1; PROFILE=PROMETHEUS ;;
  *) echo "Invalid selection"; exit 2 ;;
esac

if [[ "$END" == "1" ]]; then
  cat <<'ENFORCEMENT_MENU'

Choose SessionEnd enforcement:
1) block (default, wait for completion and fail the hook on terminal errors)
2) report (wait for completion, write feedback, and exit zero)
ENFORCEMENT_MENU
  read -r -p "Enforcement [1-2]: " enforcement_choice
  enforcement_choice="${enforcement_choice:-1}"
  case "$enforcement_choice" in
    1) ENFORCEMENT=block ;;
    2) ENFORCEMENT=report ;;
    *) echo "Invalid enforcement selection"; exit 2 ;;
  esac
fi

preview="$(cat <<EOF
PHX_SESSION_START_ENABLED=$START
PHX_SESSION_END_ENABLED=$END
PHX_SESSION_END_ENFORCEMENT=$ENFORCEMENT
PHX_SESSION_PROFILE=$PROFILE
PHX_SESSION_TIMEOUT_SECONDS=900
PHX_SESSION_POLL_SECONDS=10
EOF
)"

echo ""
echo "Final session hook config:"
printf '%s\n' "$preview"
echo ""
read -r -p "Write $CONFIG_FILE? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "No changes written."
  exit 0
fi

printf '%s\n' "$preview" > "$CONFIG_FILE"
echo "Wrote $CONFIG_FILE"
echo "Selected profile: $PROFILE (start=$START, end=$END, enforcement=$ENFORCEMENT)"
echo "Re-run installer with --with-session-scan to merge hook commands into .claude/settings.json."
echo "Use scripts/purple session configure to revisit this later, or --configure-session-hooks during install to run it automatically."
