#!/usr/bin/env bash
set -euo pipefail

PHX_ROOT="/Users/francescocipollone/Documents/GitHub/agent-code-analyzer-r2-bench"
PHX_BACKEND_DIR="$PHX_ROOT/code-analyzer-service"

case "${1:-}" in
  --print-command)
    printf 'cd "%s" && ./gradlew bootRun --args=%q\n' "$PHX_BACKEND_DIR" "--mcp.mode=stdio"
    exit 0
    ;;
  --doctor)
    exec bash "$PHX_ROOT/scripts/purple" doctor "${CLAUDE_PROJECT_DIR:-$PWD}"
    ;;
  "")
    ;;
  *)
    echo "Usage: bash scripts/purplephx-mcp.sh [--print-command|--doctor]" >&2
    exit 2
    ;;
esac

cd "$PHX_BACKEND_DIR"
exec ./gradlew bootRun --args='--mcp.mode=stdio'
