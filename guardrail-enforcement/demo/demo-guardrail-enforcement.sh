#!/usr/bin/env bash
# demo-guardrail-enforcement.sh — sales-engineer demo of the Phoenix guardrail
# pack and its blocking enforcement hook.
#
# Design: docs/plans/2026-09-15-guardrail-enforcement-installer-design.md
#
# WHAT THIS DEMONSTRATES
#   A commit carrying a new CRITICAL finding is refused by a PreToolUse hook,
#   before the commit happens, inside the developer's own agent session.
#
# WHAT IT DOES NOT DEMONSTRATE
#   --mode mock serves canned findings from a local server. It proves the
#   MECHANISM, never the scanner. Say that out loud on stage; the pack's own
#   enforcement doc makes the same distinction and a customer will respect it.
#
# HOW THE HOOK IS DRIVEN
#   Claude Code fires a PreToolUse hook by piping a JSON payload to the script
#   on stdin and reading its exit code: 2 means "block this tool call". This
#   demo sends exactly that payload. It is the real contract, run deterministically
#   instead of hoping a live model decides to commit on cue. Step 9 prints the
#   command to reproduce it in a real Claude Code session.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALLER="$PACK_DIR/install-guardrails.sh"
MOCK="$SCRIPT_DIR/mock-phoenix-api.py"

# Left EMPTY on purpose. A value is only filled in AFTER argument parsing and
# AFTER the env file is loaded, so the script can tell "the user passed --mode"
# apart from "--mode was never given". That ordering is what makes the
# precedence chain below work.
MODE=""
TARGET=""
PORT=""
ENV_FILE=""
PAUSE=1
KEEP=0
WORKDIR=""
MOCK_PID=""

# --- settings file ----------------------------------------------------------
# Settings come from four places. Strongest first:
#
#   1. a command-line flag
#   2. a variable already exported in the operator's shell
#   3. demo.env  (or --env-file)
#   4. the built-in default below
#
# So an exported PHX_API_TOKEN always beats one written in the file. That order
# matters on a shared laptop: the file is a convenience, never an override of
# the credential the operator deliberately put in their own environment.
#
# The file is READ, never SOURCED. Sourcing would execute whatever is in it,
# and a settings file is not a place to run code.
load_env_file() { # <path>
  local f="$1" line key val
  [ -f "$f" ] || return 0
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ''|'#'*) continue ;; esac
    case "$line" in *=*) ;; *) continue ;; esac
    key="${line%%=*}"
    val="${line#*=}"
    key="$(printf '%s' "$key" | tr -d '[:space:]')"
    # Anything that is not a plain variable name is skipped rather than guessed at.
    case "$key" in ''|*[!A-Za-z0-9_]*) continue ;; esac
    # Strip one matching pair of surrounding quotes, if present.
    case "$val" in
      \"*\") val="${val#\"}"; val="${val%\"}" ;;
      \'*\') val="${val#\'}"; val="${val%\'}" ;;
    esac
    # Rule 2 beats rule 3: never clobber a value the shell already carries.
    if [ -z "${!key:-}" ]; then
      export "$key=$val"
    fi
  done < "$f"
}

C_B=$'\033[1m'; C_R=$'\033[31m'; C_G=$'\033[32m'; C_Y=$'\033[33m'; C_0=$'\033[0m'
[ -t 1 ] || { C_B=""; C_R=""; C_G=""; C_Y=""; C_0=""; }

usage() {
  cat <<'HELPTEXT'
demo-guardrail-enforcement.sh — demo the Phoenix guardrail + enforcement hook

  --mode live|mock   live: real Phoenix backend, needs PHX_API_TOKEN (default)
                     mock: local fake backend, no token, no network
  --target <repo>    Repo to demo against. REQUIRED for --mode live: it must be
                     a repo already onboarded in Phoenix, or the scan resolve
                     call fails and the gate SKIPS. The repo is cloned to a temp
                     directory; your working copy is never touched.
                     Optional for --mode mock (a throwaway repo is built).
  --port <n>         Mock server port                              (default 4250)
  --env-file <path>  Settings file to load.        (default: demo/demo.env if it exists)
                     Copy demo.env.example to demo.env and edit it. A flag beats
                     your shell environment, which beats the file.
  --no-pause         Do not wait for a keypress between steps (for CI)
  --keep             Keep the temp directory and print its path
  -h, --help         This text

EXAMPLES
  cp demo/demo.env.example demo/demo.env   # then put your token in it
  ./demo/demo-guardrail-enforcement.sh                 # reads demo/demo.env

  ./demo/demo-guardrail-enforcement.sh --mode mock     # no token, no network
  PHX_API_TOKEN=xxx ./demo/demo-guardrail-enforcement.sh --mode live --target ~/src/my-repo
HELPTEXT
}

die() { printf '%sERROR:%s %s\n' "$C_R" "$C_0" "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --mode)     MODE="${2:-}"; shift 2 ;;
    --target)   TARGET="${2:-}"; shift 2 ;;
    --port)     PORT="${2:-}"; shift 2 ;;
    --env-file) ENV_FILE="${2:-}"; shift 2 ;;
    --no-pause) PAUSE=0; shift ;;
    --keep)     KEEP=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

# Load the settings file now: after the flags are known (so --env-file is
# honoured) and before any default is applied (so the file can supply one).
if [ -n "$ENV_FILE" ]; then
  [ -f "$ENV_FILE" ] || die "--env-file not found: $ENV_FILE"
  load_env_file "$ENV_FILE"
  ENV_SRC="$ENV_FILE"
elif [ -f "$SCRIPT_DIR/demo.env" ]; then
  load_env_file "$SCRIPT_DIR/demo.env"
  ENV_SRC="$SCRIPT_DIR/demo.env"
else
  ENV_SRC=""
fi

# Resolve each setting down the precedence chain: flag, then environment (which
# load_env_file has already merged the file into), then built-in default.
MODE="${MODE:-${PHX_DEMO_MODE:-live}}"
TARGET="${TARGET:-${PHX_DEMO_TARGET:-}}"
PORT="${PORT:-${PHX_DEMO_PORT:-4250}}"
POLICY_MODE="${PHX_DEMO_POLICY_MODE:-BLOCK}"
BLOCKING_SEVERITIES="${PHX_DEMO_BLOCKING_SEVERITIES:-[\"CRITICAL\",\"HIGH\"]}"
MOCK_TOKEN="${PHX_DEMO_MOCK_TOKEN:-mockdemotoken}"

case "$MODE" in live|mock) ;; *) die "--mode must be live or mock" ;; esac
command -v jq   >/dev/null 2>&1 || die "jq is required"
command -v git  >/dev/null 2>&1 || die "git is required"
command -v curl >/dev/null 2>&1 || die "curl is required"
[ -x "$INSTALLER" ] || die "installer not found or not executable: $INSTALLER"

if [ "$MODE" = "live" ]; then
  [ -n "${PHX_API_TOKEN:-}" ] || die "--mode live needs PHX_API_TOKEN exported. Use --mode mock for an offline demo."
  [ -n "$TARGET" ] || die "--mode live needs --target <repo already onboarded in Phoenix>."
  [ -d "$TARGET/.git" ] || die "--target is not a git repository: $TARGET"
else
  command -v python3 >/dev/null 2>&1 || die "--mode mock needs python3"
  [ -f "$MOCK" ] || die "mock server not found: $MOCK"
fi

# --- presentation helpers ---------------------------------------------------
STEP_N=0
step() {
  STEP_N=$((STEP_N + 1))
  printf '\n%s────────────────────────────────────────────────────────────%s\n' "$C_B" "$C_0"
  printf '%s STEP %d — %s%s\n' "$C_B" "$STEP_N" "$*" "$C_0"
  printf '%s────────────────────────────────────────────────────────────%s\n' "$C_B" "$C_0"
}
say()  { printf '  %s\n' "$*"; }
good() { printf '  %s%s%s\n' "$C_G" "$*" "$C_0"; }
bad()  { printf '  %s%s%s\n' "$C_R" "$*" "$C_0"; }
warn() { printf '  %s%s%s\n' "$C_Y" "$*" "$C_0"; }
run()  { printf '  %s$ %s%s\n' "$C_Y" "$*" "$C_0"; }
pause() { [ "$PAUSE" = "1" ] && read -r -p "  ⏎ press enter " _ || true; }

cleanup() {
  [ -n "$MOCK_PID" ] && kill "$MOCK_PID" 2>/dev/null
  if [ -n "$WORKDIR" ] && [ -d "$WORKDIR" ]; then
    if [ "$KEEP" = "1" ]; then
      printf '\n  kept: %s\n' "$WORKDIR"
    else
      rm -rf "$WORKDIR"
    fi
  fi
}
trap cleanup EXIT INT TERM

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/phx-guardrail-demo.XXXXXX")"
# The gate writes its policy cache, receipts and log under $PHX_HOME. Pointing it
# at the demo directory keeps the developer's real ~/.phoenix untouched AND
# guarantees no stale cached policy from a previous run decides this one.
export PHX_HOME="$WORKDIR/phoenix-home"
mkdir -p "$PHX_HOME"
GATE_LOG="$PHX_HOME/enforcement-policy/gate.log"

VULN_FILE="src/profile.js"
VULN_LINE=4
STATE_FILE="$WORKDIR/mock-state"

printf '%s\n' "$C_B"
cat <<'BANNER'
  Phoenix Security — Guardrails & Enforcement Hook
  ------------------------------------------------
  Three layers of control ship with this pack. Only one of them
  survives a developer who does not want it:

    A. ADVISORY   guardrail rules + CLAUDE.md   — the model can ignore it
    B. AUTOMATIC  PreToolUse gate hook          — blocks, but is deletable
    C. ENFORCED   server-side PR policy         — nothing local can bypass it

  This demo installs A and B. It never claims to install C.
BANNER
printf '%s' "$C_0"
say ""
say "mode:     $MODE"
say "policy:   $POLICY_MODE, blocking $BLOCKING_SEVERITIES"
say "settings: ${ENV_SRC:-(no demo.env — flags and shell environment only)}"
say "workdir:  $WORKDIR"
pause

# ============================================================================
step "Build the demo repository"
if [ -n "$TARGET" ]; then
  REPO_NAME="$(basename "$TARGET")"
  REPO="$WORKDIR/$REPO_NAME"
  run "git clone --local '$TARGET' '$REPO'"
  git clone --local --quiet "$TARGET" "$REPO" 2>/dev/null \
    || die "clone failed. Is $TARGET a git repo with at least one commit?"
  say "Cloned. Your working copy at $TARGET is not touched."
else
  REPO_NAME="acme-web"
  REPO="$WORKDIR/$REPO_NAME"
  mkdir -p "$REPO/src"
  git -C "$REPO" init --quiet
  git -C "$REPO" symbolic-ref HEAD refs/heads/main
  printf '# %s\n\nA small web app.\n' "$REPO_NAME" > "$REPO/README.md"
  git -C "$REPO" add -A
  git -C "$REPO" -c user.email=demo@phoenix.security -c user.name="Phoenix Demo" \
    commit --quiet -m "initial commit"
  say "Built a throwaway repo: $REPO_NAME"
fi
git -C "$REPO" config user.email "demo@phoenix.security"
git -C "$REPO" config user.name  "Phoenix Demo"
run "git -C $REPO_NAME log --oneline -1"
git -C "$REPO" log --oneline -1 | sed 's/^/  /'
pause

# ============================================================================
step "BEFORE — an unprotected repo accepts a vulnerable commit"
say "A developer's agent writes a profile page. It puts user input straight"
say "into innerHTML. That is CWE-79, cross-site scripting."
mkdir -p "$REPO/src"
cat > "$REPO/$VULN_FILE" <<'VULN1'
// Renders the user profile card.
export function renderProfile(user) {
  const el = document.getElementById("profile");
  el.innerHTML = "<h2>" + user.displayName + "</h2>";
  return el;
}
VULN1
run "cat $VULN_FILE"
sed 's/^/  │ /' "$REPO/$VULN_FILE"
say ""
run "git add $VULN_FILE && git commit -m 'add profile card'"
git -C "$REPO" add "$VULN_FILE"
git -C "$REPO" commit --quiet -m "add profile card"
bad "COMMITTED. Nothing checked it. Nothing warned anyone."
pause

# ============================================================================
step "Install the guardrail pack"
INSTALL_ARGS=(--target "$REPO" --platforms all --mode "$POLICY_MODE"
              --blocking-severities "$BLOCKING_SEVERITIES")
[ -n "${PHX_ORG_ID:-}" ]       && INSTALL_ARGS+=(--org-id "$PHX_ORG_ID")
[ -n "${PHX_WORKSPACE_ID:-}" ] && INSTALL_ARGS+=(--workspace-id "$PHX_WORKSPACE_ID")
if [ "$MODE" = "mock" ]; then
  INSTALL_ARGS+=(--api-base "http://127.0.0.1:$PORT")
elif [ -n "${PHX_API_BASE:-}" ]; then
  INSTALL_ARGS+=(--api-base "$PHX_API_BASE")
fi
run "install-guardrails.sh ${INSTALL_ARGS[*]}"
"$INSTALLER" "${INSTALL_ARGS[@]}" || die "installer failed"
pause

# ============================================================================
step "What the installer put in the repository"
run "git -C $REPO_NAME status --short | head -20"
git -C "$REPO" status --short 2>/dev/null | head -20 | sed 's/^/  /'
say ""
say "The pieces that matter:"
say "  .claude/rules/*.md            52 advisory guardrails   (layer A)"
say "  .cursor/rules/*.mdc           same rules, for Cursor   (layer A)"
say "  .gemini/security/*.md         same rules, for Gemini   (layer A)"
say "  AGENTS.md                     same rules, for Codex    (layer A)"
say "  scripts/purplephx-gate.sh     the blocking hook        (layer B)"
say "  .claude/settings.json         wires the hook to PreToolUse"
say ""
run "jq '.hooks.PreToolUse[0].hooks[0].command' $REPO_NAME/.claude/settings.json"
jq -r '.hooks.PreToolUse[0].hooks[0].command' "$REPO/.claude/settings.json" | sed 's/^/  /'
warn "Only Claude Code got the blocking hook. No other agent has PreToolUse."
pause

# ============================================================================
if [ "$MODE" = "mock" ]; then
step "Start the local mock Phoenix API"
printf 'vulnerable\n' > "$STATE_FILE"
MOCK_PORT="$PORT" MOCK_MODE="$POLICY_MODE" MOCK_SEVERITIES="$BLOCKING_SEVERITIES" \
MOCK_FINDING_PATH="$VULN_FILE" MOCK_FINDING_LINE="$VULN_LINE" \
MOCK_STATE_FILE="$STATE_FILE" \
  python3 "$MOCK" 2>"$WORKDIR/mock.log" &
MOCK_PID=$!
for _ in 1 2 3 4 5 6 7 8 9 10; do
  curl -s -o /dev/null "http://127.0.0.1:$PORT/api/v1/external/purplephx/enforcement-policy" && break
  sleep 0.3
done
kill -0 "$MOCK_PID" 2>/dev/null || { cat "$WORKDIR/mock.log"; die "mock server did not start"; }
good "Mock API up on http://127.0.0.1:$PORT"
run "curl -s localhost:$PORT/api/v1/external/purplephx/enforcement-policy | jq"
curl -s "http://127.0.0.1:$PORT/api/v1/external/purplephx/enforcement-policy" | jq . | sed 's/^/  /'
warn "THIS IS A MOCK. The findings are canned. It proves the hook, not the scanner."
# Mock mode still needs a token, because the gate SKIPS without one — and a skip
# would make the demo prove nothing. This is not a credential: the mock server is
# local and ignores it. It only has to satisfy the gate's charset check.
export PHX_API_TOKEN="$MOCK_TOKEN"

# Mock mode OWNS these two, and overrides whatever demo.env or the operator's
# shell put there. The gate resolves PHX_API_BASE from the environment FIRST and
# only falls back to its baked value when the environment is empty — so a
# PHX_API_BASE left over from demo.env silently retargets the gate at the real
# backend while this demo reports the mock server as up. That is the exact shape
# of failure the pack exists to prevent, reproduced by its own demo.
export PHX_API_BASE="http://127.0.0.1:$PORT"
# Org and workspace ids belong to the real backend, not the mock. Carrying them
# over makes the mock's answers look scoped when they are not.
unset PHX_ORG_ID PHX_WORKSPACE_ID
pause
fi

# ============================================================================
# The exact payload Claude Code writes to a PreToolUse hook's stdin.
gate_payload() { # <command>
  jq -cn --arg cmd "$1" --arg cwd "$REPO" \
    '{hook_event_name:"PreToolUse", tool_name:"Bash",
      session_id:"demo-session", cwd:$cwd,
      tool_input:{command:$cmd}}'
}

run_gate() { # <command> -> prints output, returns the gate's exit code
  local out err rc msg
  err="$WORKDIR/gate.err"
  out="$(gate_payload "$1" | bash "$REPO/scripts/purplephx-gate.sh" 2>"$err")"
  rc=$?
  # On a deny the gate deliberately emits the SAME text on both channels: the
  # JSON decision on stdout and a plain copy on stderr, so a block survives a
  # JSON defect. For the demo that is one message printed twice, so stderr is
  # shown only when stdout carried no message of its own.
  msg="$(printf '%s' "$out" | jq -r '.hookSpecificOutput.permissionDecisionReason
                                      // .hookSpecificOutput.additionalContext // empty' 2>/dev/null)"
  if [ -z "$msg" ] && [ -s "$err" ]; then
    sed 's/^/  │ /' "$err"
  fi
  if [ -n "$msg" ]; then
    printf '%s\n' "$msg" | sed 's/^/  │ /'
  elif [ -n "$out" ]; then
    printf '  │ %s\n' "$out"
  fi
  return $rc
}

step "AFTER — the same class of change, now with the gate installed"
say "The agent writes a second vulnerable file and stages it for commit."
cat > "$REPO/$VULN_FILE" <<'VULN2'
// Renders the user profile card.
export function renderProfile(user) {
  const el = document.getElementById("profile");
  el.innerHTML = "<h2>" + user.displayName + "</h2>" + user.bio;
  return el;
}
VULN2
git -C "$REPO" add "$VULN_FILE"
run "git add $VULN_FILE   # staged, not yet committed"
say ""
say "Claude Code now tries to run: git commit -m 'render user bio'"
say "Before the Bash tool runs, it pipes this to the hook on stdin:"
gate_payload "git commit -m 'render user bio'" | jq . | sed 's/^/  │ /'
pause
say ""
run "purplephx-gate.sh  < PreToolUse payload"
run_gate "git commit -m 'render user bio'"
RC_VULN=$?
say ""
if [ "$RC_VULN" = "2" ]; then
  bad "EXIT CODE 2 — the commit was BLOCKED before it happened."
elif [ "$RC_VULN" = "0" ]; then
  warn "EXIT CODE 0 — not blocked. Read the message above: an ADVISORY policy"
  warn "reports without blocking, and a SKIP means nothing was verified at all."
  warn "A skip is not a pass."
else
  warn "EXIT CODE $RC_VULN — unexpected. See $GATE_LOG"
fi
pause

# ============================================================================
step "Fix the finding, then try again"
cat > "$REPO/$VULN_FILE" <<'FIXED'
// Renders the user profile card.
export function renderProfile(user) {
  const el = document.getElementById("profile");
  el.textContent = user.displayName + " — " + user.bio;
  return el;
}
FIXED
run "cat $VULN_FILE"
sed 's/^/  │ /' "$REPO/$VULN_FILE"
good "innerHTML replaced with textContent. The sink is gone."
git -C "$REPO" add "$VULN_FILE"
if [ "$MODE" = "mock" ]; then
  printf 'clean\n' > "$STATE_FILE"
  say "(mock: the canned scan result is now empty)"
fi
say ""
run "purplephx-gate.sh  < PreToolUse payload"
run_gate "git commit -m 'render user bio safely'"
RC_FIXED=$?
say ""
if [ "$RC_FIXED" = "0" ]; then
  good "EXIT CODE 0 — the commit is allowed through."
else
  warn "EXIT CODE $RC_FIXED — still blocked. See $GATE_LOG"
fi
pause

# ============================================================================
step "The audit trail"
say "Every decision the gate makes is one JSON line. A missing line is itself"
say "the signal: it means the gate never ran."
run "cat \$PHX_HOME/enforcement-policy/gate.log"
if [ -f "$GATE_LOG" ]; then
  jq -c '{ts,gate,mode,verdict,reason,newFindings,skipReason}' "$GATE_LOG" 2>/dev/null \
    | sed 's/^/  │ /' || sed 's/^/  │ /' "$GATE_LOG"
else
  warn "No gate.log at $GATE_LOG — the gate never ran. That is the failure signal."
fi
pause

# ============================================================================
step "What you just saw, and what you did not"
printf '\n'
if [ "$RC_VULN" = "2" ]; then
  say "SAW:  a CRITICAL finding introduced by a staged change stopped a commit"
  say "      inside the agent session, with exit code 2, before any code landed."
else
  bad "NOT SEEN: the commit was NOT blocked (exit $RC_VULN). Whatever the steps"
  bad "      above narrated, this run did not demonstrate a block. Check the"
  bad "      gate.log line: a \"skip\" means the gate never verified anything."
fi
say "SAW:  the same guardrail rules installed for Claude Code, Cursor, Gemini"
say "      and Codex from one command."
printf '\n'
if [ "$MODE" = "mock" ]; then
  warn "DID NOT SEE: a real scan. --mode mock serves canned findings."
  warn "             Run with --mode live --target <onboarded repo> for the real thing."
fi
say "DID NOT SEE: layer C. This hook lives on the developer's machine. A"
say "      developer who deletes scripts/purplephx-gate.sh deletes the control."
say "      For a gate they cannot remove, configure a server-side PR policy in"
say "      the Phoenix Security dashboard, Enforcement tab."
printf '\n'
say "To reproduce this in a REAL Claude Code session:"
if [ "$KEEP" = "1" ]; then
  run "cd $REPO && export PHX_API_TOKEN=... && claude"
else
  run "./demo/demo-guardrail-enforcement.sh --mode $MODE --keep"
  say "  then:  cd <the kept repo> && claude    and ask it to commit."
fi
printf '\n'

if [ "$RC_VULN" = "2" ] && [ "$RC_FIXED" = "0" ]; then
  good "DEMO RESULT: PASS  (blocked=2 on the finding, allowed=0 after the fix)"
  exit 0
fi
warn "DEMO RESULT: INCOMPLETE  (vulnerable=$RC_VULN, fixed=$RC_FIXED) — expected 2 then 0"
exit 1
