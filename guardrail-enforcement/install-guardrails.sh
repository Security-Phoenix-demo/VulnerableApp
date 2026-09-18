#!/usr/bin/env bash
# install-guardrails.sh — install the Phoenix guardrail pack and the enforcement
# gate hook into any target repository.
#
# Design: docs/plans/2026-09-15-guardrail-enforcement-installer-design.md
#
# What this installs, and the honest name for each layer:
#
#   A. ADVISORY  — the 52 guardrail rules and the CLAUDE.md block. Guidance text
#                  competing with every other token in the model's context.
#   B. AUTOMATIC — the PreToolUse gate hook. It genuinely blocks `git commit`,
#                  `git push` and `gh pr create`, but a developer can delete it.
#   C. ENFORCED  — server-side PR policy. NOT installed here. Nothing local can
#                  provide it.
#
# This script never claims to install layer C.
set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GUARDRAILS_DIR="$PACK_DIR/guardrails"
ENFORCEMENT_DIR="$PACK_DIR/enforcement"

MARK_START="PHX-GUARDRAIL-START"
MARK_END="PHX-GUARDRAIL-END"

ALL_PLATFORMS="claude_code cursor gemini_cli codex_cli"

# --- defaults ---------------------------------------------------------------
TARGET="$PWD"
PLATFORMS_ARG="auto"
ORG_ID=""
WORKSPACE_ID=""
POLICY_MODE="ADVISORY"
BLOCKING_SEVERITIES='[]'
COMMIT_DOMAINS='["SAST","SECRETS"]'
PUSH_DOMAINS='["SAST","SCA"]'
API_BASE=""
DRY_RUN=0
UNINSTALL=0

usage() {
  cat <<'HELPTEXT'
install-guardrails.sh — install Phoenix guardrails + enforcement hook into a repo

USAGE
  ./install-guardrails.sh --target <repo> [options]

OPTIONS
  --target <path>              Repo to install into.               (default: $PWD)
  --platforms <list>           all | auto | comma list of:
                               claude_code,cursor,gemini_cli,codex_cli
                                                                   (default: auto)
  --org-id <id>                Baked into the gate as __PHX_ORG_ID__
  --workspace-id <id>          Baked into the gate as __PHX_WORKSPACE_ID__
  --mode <M>                   ADVISORY | GATE | BLOCK             (default: ADVISORY)
  --blocking-severities <json> JSON array, e.g. '["CRITICAL","HIGH"]'
  --commit-domains <json>      JSON array                 (default: ["SAST","SECRETS"])
  --push-domains <json>        JSON array                 (default: ["SAST","SCA"])
  --api-base <url>             Override the baked Phoenix API base URL
  --dry-run                    Print every change, write nothing
  --uninstall                  Remove exactly what this script installed
  -h, --help                   This text

WHAT GETS INSTALLED
  Guardrails (advisory) for every detected platform.
  The blocking gate hook for claude_code ONLY — no other agent has PreToolUse.

EXAMPLES
  ./install-guardrails.sh --target ../my-repo --platforms auto
  ./install-guardrails.sh --target ../my-repo --mode BLOCK \
      --blocking-severities '["CRITICAL","HIGH"]' \
      --org-id 6f6efefa-0000-0000-0000-000000000000
  ./install-guardrails.sh --target ../my-repo --uninstall
HELPTEXT
}

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf '  %s\n' "$*"; }
# Goes to stderr, like die, because a warning that scrolls past in a successful install
# is a warning nobody reads. The install still succeeds — this is not a die.
warn() { printf '  WARNING: %s\n' "$*" >&2; }
step() { printf '\n== %s\n' "$*"; }

# --- arg parsing ------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --target)              TARGET="${2:-}"; shift 2 ;;
    --platforms)           PLATFORMS_ARG="${2:-}"; shift 2 ;;
    --org-id)              ORG_ID="${2:-}"; shift 2 ;;
    --workspace-id)        WORKSPACE_ID="${2:-}"; shift 2 ;;
    --mode)                POLICY_MODE="${2:-}"; shift 2 ;;
    --blocking-severities) BLOCKING_SEVERITIES="${2:-}"; shift 2 ;;
    --commit-domains)      COMMIT_DOMAINS="${2:-}"; shift 2 ;;
    --push-domains)        PUSH_DOMAINS="${2:-}"; shift 2 ;;
    --api-base)            API_BASE="${2:-}"; shift 2 ;;
    --dry-run)             DRY_RUN=1; shift ;;
    --uninstall)           UNINSTALL=1; shift ;;
    -h|--help)             usage; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

command -v jq >/dev/null 2>&1 || die "jq is required (the gate script needs it too). Install jq and re-run."

[ -n "$TARGET" ] || die "--target must not be empty"
[ -d "$TARGET" ] || die "target directory does not exist: $TARGET"
TARGET="$(cd "$TARGET" && pwd)"
[ -d "$GUARDRAILS_DIR" ] || die "guardrail pack not found at $GUARDRAILS_DIR"
[ -d "$ENFORCEMENT_DIR" ] || die "enforcement pack not found at $ENFORCEMENT_DIR"

case "$POLICY_MODE" in
  ADVISORY|GATE|BLOCK) ;;
  *) die "--mode must be ADVISORY, GATE or BLOCK (got '$POLICY_MODE')" ;;
esac
for v in "$BLOCKING_SEVERITIES" "$COMMIT_DOMAINS" "$PUSH_DOMAINS"; do
  printf '%s' "$v" | jq -e 'type == "array"' >/dev/null 2>&1 \
    || die "not a JSON array: $v"
done

# These three are written into SINGLE-quoted bash assignments in the gate script.
# A single quote inside one of them would close that assignment early and turn
# the rest of the value into shell code. jq's own compact output never emits one,
# so a value containing one is either a mistake or an injection attempt.
for v in "$BLOCKING_SEVERITIES" "$COMMIT_DOMAINS" "$PUSH_DOMAINS"; do
  case "$v" in *"'"*) die "JSON array must not contain a single quote: $v" ;; esac
done
# Baked into double-quoted assignments and into a URL. Restrict to the charset
# the gate itself accepts for identifiers so nothing can be smuggled in.
for v in "$ORG_ID" "$WORKSPACE_ID"; do
  [ -z "$v" ] && continue
  case "$v" in *[!A-Za-z0-9._-]*) die "id must match [A-Za-z0-9._-]: $v" ;; esac
done
case "$API_BASE" in
  ""|http://*|https://*) ;;
  *) die "--api-base must start with http:// or https:// (got '$API_BASE')" ;;
esac
case "$API_BASE" in *[\"\'\$\`]*) die "--api-base contains a quote or expansion character" ;; esac

# --- dry-run plumbing -------------------------------------------------------
# Every mutating action goes through phx_do so --dry-run is total, not partial.
phx_do() {
  if [ "$DRY_RUN" = "1" ]; then
    printf '  [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# --- marker block helpers ---------------------------------------------------
# Append <content-file> to <file>, fenced by markers. Any pre-existing block with
# the same markers is removed first, so re-running replaces instead of duplicating.
phx_block_strip() { # <file> <comment-open> <comment-close>
  local f="$1" co="$2" cc="$3" tmp
  [ -f "$f" ] || return 0
  grep -q "$MARK_START" "$f" 2>/dev/null || return 0
  tmp="$(mktemp)"
  # Drop the fenced block, then drop the blank lines the block left behind, so
  # uninstall restores the file byte-for-byte instead of growing a blank line
  # every install/uninstall cycle. `blanks` buffers pending empty lines and only
  # emits them once real content follows.
  awk -v s="$MARK_START" -v e="$MARK_END" '
    index($0, s) { skip = 1 }
    !skip {
      if ($0 ~ /^[[:space:]]*$/) { blanks++ ; next }
      while (blanks-- > 0) print ""
      blanks = 0
      print
    }
    index($0, e) { skip = 0 }
  ' "$f" > "$tmp"
  mv -f "$tmp" "$f"
}

phx_block_write() { # <file> <content-file> <comment-open> <comment-close>
  local f="$1" src="$2" co="$3" cc="$4"
  phx_block_strip "$f" "$co" "$cc"
  {
    [ -s "$f" ] && printf '\n'
    printf '%s %s %s\n' "$co" "$MARK_START" "$cc"
    cat "$src"
    printf '%s %s %s\n' "$co" "$MARK_END" "$cc"
  } >> "$f"
}

# Delete a file only if stripping our block left it empty (i.e. we created it).
# A file the project already had keeps its own content and is never removed.
phx_rm_if_empty() { # <file>
  [ -f "$1" ] || return 0
  [ -s "$1" ] && [ -n "$(tr -d '[:space:]' < "$1")" ] && return 0
  phx_do rm -f "$1"
  info "removed empty $(basename "$1") (this script created it)"
}

# --- platform resolution ----------------------------------------------------
phx_detect_platforms() {
  local found=""
  [ -d "$TARGET/.claude" ]  && found="$found claude_code"
  [ -d "$TARGET/.cursor" ]  && found="$found cursor"
  { [ -f "$TARGET/GEMINI.md" ] || [ -d "$TARGET/.gemini" ]; } && found="$found gemini_cli"
  [ -f "$TARGET/AGENTS.md" ] && found="$found codex_cli"
  printf '%s' "${found# }"
}

case "$PLATFORMS_ARG" in
  all)  PLATFORMS="$ALL_PLATFORMS" ;;
  auto)
    PLATFORMS="$(phx_detect_platforms)"
    if [ -z "$PLATFORMS" ]; then
      PLATFORMS="claude_code"
      info "auto-detect found no agent config; defaulting to claude_code"
    fi
    ;;
  *)    PLATFORMS="$(printf '%s' "$PLATFORMS_ARG" | tr ',' ' ')" ;;
esac

for p in $PLATFORMS; do
  case " $ALL_PLATFORMS " in
    *" $p "*) ;;
    *) die "unknown platform '$p' (valid: $ALL_PLATFORMS)" ;;
  esac
done

# --- per-platform guardrail install ----------------------------------------
phx_install_guardrails() { # <platform>
  local p="$1" src dst n
  case "$p" in
    claude_code)
      src="$GUARDRAILS_DIR/claude_code/.claude/rules"; dst="$TARGET/.claude/rules" ;;
    cursor)
      src="$GUARDRAILS_DIR/cursor/.cursor/rules";      dst="$TARGET/.cursor/rules" ;;
    gemini_cli)
      src="$GUARDRAILS_DIR/gemini_cli/security";       dst="$TARGET/.gemini/security" ;;
    codex_cli)
      # Codex has no rules directory: its pack is one AGENTS.md, appended in place.
      local agents="$GUARDRAILS_DIR/codex_cli/AGENTS.md"
      [ -f "$agents" ] || { info "codex_cli: no AGENTS.md in pack, skipped"; return 0; }
      info "codex_cli: appending $(wc -l < "$agents" | tr -d ' ') lines into $TARGET/AGENTS.md"
      phx_do phx_block_write "$TARGET/AGENTS.md" "$agents" "<!--" "-->"
      return 0 ;;
  esac
  [ -d "$src" ] || { info "$p: no rules in pack at $src, skipped"; return 0; }
  n="$(find "$src" -maxdepth 1 -type f | wc -l | tr -d ' ')"
  info "$p: $n rule files -> ${dst#"$TARGET"/}"
  phx_do mkdir -p "$dst"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  [dry-run] cp %s/* %s/\n' "$src" "$dst"
  else
    find "$src" -maxdepth 1 -type f -exec cp -f {} "$dst"/ \;
  fi
}

phx_uninstall_guardrails() { # <platform>
  local p="$1" src dst f base
  case "$p" in
    claude_code) src="$GUARDRAILS_DIR/claude_code/.claude/rules"; dst="$TARGET/.claude/rules" ;;
    cursor)      src="$GUARDRAILS_DIR/cursor/.cursor/rules";      dst="$TARGET/.cursor/rules" ;;
    gemini_cli)  src="$GUARDRAILS_DIR/gemini_cli/security";       dst="$TARGET/.gemini/security" ;;
    codex_cli)
      info "codex_cli: stripping guardrail block from AGENTS.md"
      phx_do phx_block_strip "$TARGET/AGENTS.md" "<!--" "-->"
      phx_rm_if_empty "$TARGET/AGENTS.md"
      return 0 ;;
  esac
  [ -d "$src" ] || return 0
  # Remove only files this pack owns, by name. Never `rm -rf` the directory:
  # the project may keep its own rules alongside ours.
  while IFS= read -r f; do
    base="$(basename "$f")"
    [ -f "$dst/$base" ] || continue
    phx_do rm -f "$dst/$base"
  done < <(find "$src" -maxdepth 1 -type f)
  info "$p: removed pack rules from ${dst#"$TARGET"/}"
}

# --- enforcement hook (claude_code only) ------------------------------------
phx_install_enforcement() {
  local gate_tpl="$ENFORCEMENT_DIR/scripts/purplephx-gate.sh.template"
  local rule_tpl="$ENFORCEMENT_DIR/rules/purple-scan-enforcement.md.template"
  local md_tpl="$ENFORCEMENT_DIR/PHX_PURPLE_ENFORCEMENT.md.template"
  local hook_tpl="$ENFORCEMENT_DIR/.claude-hooks-gate.json.template"
  local gate_out="$TARGET/scripts/purplephx-gate.sh"
  local settings="$TARGET/.claude/settings.json"

  for f in "$gate_tpl" "$rule_tpl" "$md_tpl" "$hook_tpl"; do
    [ -f "$f" ] || die "enforcement template missing: $f"
  done

  # 1. gate script, with the six placeholders substituted.
  info "gate script -> scripts/purplephx-gate.sh (mode=$POLICY_MODE, severities=$BLOCKING_SEVERITIES)"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  [dry-run] substitute 6 placeholders into %s\n' "$gate_out"
  else
    mkdir -p "$TARGET/scripts"
    # Two different substitution shapes, because the placeholders live in two
    # different kinds of bash assignment.
    #
    #   __PHX_ORG_ID__ / __PHX_WORKSPACE_ID__  are plain identifiers. Token
    #   replacement inside the existing double-quoted assignment is correct.
    #
    #   The four policy values sit in double-quoted assignments too, but three
    #   of them are JSON ARRAYS containing their own double quotes. Substituting
    #   `["CRITICAL"]` into `PHX_BAKED_X="__PLACEHOLDER__"` yields
    #   `PHX_BAKED_X="["CRITICAL"]"`, which bash collapses to `[CRITICAL]` —
    #   invalid JSON, so the baked fallback policy silently fails to parse.
    #   Those lines are therefore REPLACED WHOLE, with single quotes, matching
    #   the style the gate itself uses for its own defaults.
    awk -v org="$ORG_ID" -v ws="$WORKSPACE_ID" \
        -v mode="$POLICY_MODE" -v sev="$BLOCKING_SEVERITIES" \
        -v cd="$COMMIT_DOMAINS" -v pd="$PUSH_DOMAINS" -v base="$API_BASE" '
      function sub_all(line, tok, val,   out, p) {
        out = ""
        while ((p = index(line, tok)) > 0) {
          out = out substr(line, 1, p - 1) val
          line = substr(line, p + length(tok))
        }
        return out line
      }
      /^PHX_BAKED_MODE=/                { printf "PHX_BAKED_MODE=\"%s\"\n", mode; next }
      /^PHX_BAKED_BLOCKING_SEVERITIES=/ { printf "PHX_BAKED_BLOCKING_SEVERITIES=%c%s%c\n", 39, sev, 39; next }
      /^PHX_BAKED_COMMIT_DOMAINS=/      { printf "PHX_BAKED_COMMIT_DOMAINS=%c%s%c\n",      39, cd,  39; next }
      /^PHX_BAKED_PUSH_DOMAINS=/        { printf "PHX_BAKED_PUSH_DOMAINS=%c%s%c\n",        39, pd,  39; next }
      /^PHX_BAKED_API_BASE=/            { if (base != "") { printf "PHX_BAKED_API_BASE=\"%s\"\n", base; next } }
      {
        l = $0
        if (org != "") l = sub_all(l, "__PHX_ORG_ID__",       org)
        if (ws  != "") l = sub_all(l, "__PHX_WORKSPACE_ID__", ws)
        print l
      }
    ' "$gate_tpl" > "$gate_out"
    if [ -n "$API_BASE" ]; then
      info "baked API base -> $API_BASE"
    else
      # Without --api-base the awk arm above leaves PHX_BAKED_API_BASE holding the
      # literal __PHX_BASE_URL__, and the gate's own phx_unsubstituted check then falls
      # back to http://localhost:4250. That is a deliberate upstream default and this
      # installer does not override it — overriding would re-fork the file this pack has
      # just finished un-forking. But it IS a surprise worth naming out loud: an operator
      # who installs with no --api-base gets a gate that talks to a port on their own
      # machine, fails to reach it, and SKIPS. A skip is not a pass, so nothing is wrongly
      # approved — but nothing is checked either, and the reason is invisible unless the
      # install says so here.
      warn "no --api-base given: the gate will use its built-in fallback http://localhost:4250"
      warn "  set PHX_API_BASE in the environment, or re-run with --api-base <url>, or the gate will SKIP every scan"
    fi
    chmod 755 "$gate_out"
  fi

  # 2. the agent-facing rule describing the hook.
  info "rule -> .claude/rules/purple-scan-enforcement.md"
  phx_do mkdir -p "$TARGET/.claude/rules"
  phx_do cp -f "$rule_tpl" "$TARGET/.claude/rules/purple-scan-enforcement.md"

  # 3. the three-layer ladder, appended to CLAUDE.md.
  info "enforcement ladder -> CLAUDE.md"
  phx_do phx_block_write "$TARGET/CLAUDE.md" "$md_tpl" "<!--" "-->"

  # 4. merge the PreToolUse wiring into .claude/settings.json.
  info "PreToolUse hook -> .claude/settings.json (jq merge, .bak written)"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  [dry-run] jq merge %s into %s\n' "$hook_tpl" "$settings"
  else
    mkdir -p "$TARGET/.claude"
    [ -f "$settings" ] || printf '{}\n' > "$settings"
    cp -f "$settings" "$settings.bak"
    jq --slurpfile add "$hook_tpl" '
        .hooks //= {}
      | .hooks.PreToolUse //= []
      # Drop any entry this installer added before, identified by the gate script
      # name in its command. Makes re-running replace instead of stacking.
      | .hooks.PreToolUse |= map(
          select(
            ((.hooks // []) | map(.command // "") | join(" ") | contains("purplephx-gate.sh")) | not
          )
        )
      | .hooks.PreToolUse += ($add[0].hooks.PreToolUse // [])
    ' "$settings.bak" > "$settings.tmp"
    mv -f "$settings.tmp" "$settings"
  fi

  # 5. keep the gate's own receipts out of git.
  info "gitignore -> .purplephx/receipts/, .purplephx/skips/"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  [dry-run] append receipt paths to %s/.gitignore\n' "$TARGET"
  else
    for pat in ".purplephx/receipts/" ".purplephx/skips/"; do
      grep -qxF "$pat" "$TARGET/.gitignore" 2>/dev/null || printf '%s\n' "$pat" >> "$TARGET/.gitignore"
    done
  fi
}

phx_uninstall_enforcement() {
  local settings="$TARGET/.claude/settings.json"
  info "removing scripts/purplephx-gate.sh"
  phx_do rm -f "$TARGET/scripts/purplephx-gate.sh"
  info "removing .claude/rules/purple-scan-enforcement.md"
  phx_do rm -f "$TARGET/.claude/rules/purple-scan-enforcement.md"
  info "stripping enforcement block from CLAUDE.md"
  phx_do phx_block_strip "$TARGET/CLAUDE.md" "<!--" "-->"
  phx_rm_if_empty "$TARGET/CLAUDE.md"
  if [ -f "$TARGET/.gitignore" ]; then
    info "removing our .gitignore entries"
    if [ "$DRY_RUN" = "1" ]; then
      printf '  [dry-run] strip receipt paths from %s/.gitignore\n' "$TARGET"
    else
      grep -vxF -e ".purplephx/receipts/" -e ".purplephx/skips/" \
        "$TARGET/.gitignore" > "$TARGET/.gitignore.tmp" || true
      mv -f "$TARGET/.gitignore.tmp" "$TARGET/.gitignore"
      phx_rm_if_empty "$TARGET/.gitignore"
    fi
  fi
  if [ -f "$settings" ]; then
    info "removing PreToolUse gate entry from .claude/settings.json"
    if [ "$DRY_RUN" = "1" ]; then
      printf '  [dry-run] jq strip gate entry from %s\n' "$settings"
    else
      cp -f "$settings" "$settings.bak"
      jq '
          if (.hooks.PreToolUse | type) == "array" then
            .hooks.PreToolUse |= map(
              select(
                ((.hooks // []) | map(.command // "") | join(" ") | contains("purplephx-gate.sh")) | not
              )
            )
          else . end
      ' "$settings.bak" > "$settings.tmp"
      mv -f "$settings.tmp" "$settings"
    fi
  fi
}

# --- main -------------------------------------------------------------------
printf 'Phoenix guardrail pack installer\n'
printf '  pack:      %s\n' "$PACK_DIR"
printf '  target:    %s\n' "$TARGET"
printf '  platforms: %s\n' "$PLATFORMS"
[ "$DRY_RUN" = "1" ] && printf '  MODE:      DRY RUN — nothing will be written\n'

has_claude=0
for p in $PLATFORMS; do [ "$p" = "claude_code" ] && has_claude=1; done

if [ "$UNINSTALL" = "1" ]; then
  step "Uninstalling guardrails (layer A)"
  for p in $PLATFORMS; do phx_uninstall_guardrails "$p"; done
  if [ "$has_claude" = "1" ]; then
    step "Uninstalling enforcement hook (layer B)"
    phx_uninstall_enforcement
  fi
  printf '\nDone. Removed.\n'
  printf 'A backup of the pre-uninstall settings.json is at\n'
  printf '  %s\n' "$TARGET/.claude/settings.json.bak"
  exit 0
fi

step "Installing guardrails — layer A, ADVISORY"
for p in $PLATFORMS; do phx_install_guardrails "$p"; done

if [ "$has_claude" = "1" ]; then
  step "Installing enforcement gate hook — layer B, AUTOMATIC"
  phx_install_enforcement
else
  step "Enforcement gate hook — SKIPPED"
  info "claude_code is not in the platform list."
  info "No other agent has a PreToolUse hook, so no blocking control was installed."
fi

cat <<SUMMARY

== Installed

  Layer A  ADVISORY   guardrail rules for: $PLATFORMS
SUMMARY
if [ "$has_claude" = "1" ]; then
  cat <<SUMMARY2
  Layer B  AUTOMATIC  PreToolUse gate, mode=$POLICY_MODE, blocking=$BLOCKING_SEVERITIES
  Layer C  ENFORCED   NOT INSTALLED — server-side PR policy is configured in the
                      Phoenix Security dashboard, not by this script.

  The gate needs PHX_API_TOKEN in your shell environment. It is never baked into
  the repo, and the gate REFUSES it if it finds it in a project-tracked file.

  It must be a key SCOPED TO THE GATE, not an ordinary API key. Mint one with
  your ordinary key, then export the result:

    curl -sS -X POST -H "Authorization: Bearer \$YOUR_API_KEY" \\
      ${API_BASE:-https://your-phoenix-host}/api/v1/external/auth/gate-key
    export PHX_API_TOKEN=<the apiKey from that response>

  An ordinary phx_live_/phx_dev_ key is REFUSED with 403 on the gate's endpoints
  ("This API key is scoped to the session gate only"), and the gate then SKIPS
  every scan. That is the one failure mode worth naming twice, because the install
  looks finished and the gate looks installed.

  Without a usable token the gate SKIPS. A skip is not a pass.
SUMMARY2
fi
printf '\n'
