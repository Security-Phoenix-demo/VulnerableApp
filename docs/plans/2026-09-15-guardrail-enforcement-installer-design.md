# Guardrail + Enforcement Installer and Sales Demo — Design

Date: 2026-09-15
Status: Approved, implementing
Scope: `guardrail-enforcement/`

## Problem

`guardrail-enforcement/` ships two halves of a product and no way to install them.

- `guardrails/` — 52 Phoenix-generated rules, pre-rendered for 4 agent tools
  (`claude_code`, `cursor`, `gemini_cli`, `codex_cli`).
- `enforcement/` — 4 templates: `scripts/purplephx-gate.sh.template` (2213 lines,
  the only artefact in the pack that can block), `.claude-hooks-gate.json.template`,
  `PHX_PURPLE_ENFORCEMENT.md.template`, `rules/purple-scan-enforcement.md.template`.

Nothing copies these into a target project, and nothing substitutes the six
placeholders the gate needs. A sales engineer therefore cannot show the hook
blocking a commit.

## Goals

1. One generic installer that installs guardrails + the enforcement hook into any repo.
2. One demo script a sales engineer can run in front of a customer, live or offline.
3. Both idempotent and fully reversible.

## Non-goals

- Changing the gate script's logic. It is treated as a sealed artefact.
- Server-side PR policy (layer C). That is platform work, not pack work.

## The three enforcement layers (from `PHX_PURPLE_ENFORCEMENT.md.template`)

| Layer | Artefact | Bypassed by |
|---|---|---|
| A. Advisory | guardrail rules, `CLAUDE.md` block | the model ignoring text |
| B. Automatic | the `PreToolUse` gate hook | deleting the hook |
| C. Enforced | server-side PR policy | nothing local |

The installer delivers A and B. The demo must state this distinction out loud,
because overclaiming "enforced" is the pack's own named failure mode.

## Decisions taken

| # | Decision | Rationale |
|---|---|---|
| D1 | Demo defaults to the **real** backend; `--mode mock` switches to a local fake | Real is the honest default; mock is the airplane/no-wifi fallback |
| D2 | Installer supports **all four** platforms, `auto`-detected | Only Claude Code has `PreToolUse`, so only it gets the blocking hook |
| D3 | `.claude/settings.json` is **merged with `jq`**, backed up to `.bak` | The demo must actually block; a paste-this-yourself file blocks nothing |
| D4 | The demo drives the gate by **piping the `PreToolUse` JSON** Claude Code would send | Deterministic on stage; prints the real exit code |

## Components

### 1. `guardrail-enforcement/install-guardrails.sh`

```
--target <path>          repo to install into (default: $PWD)
--platforms <list>       all | auto | claude_code,cursor,gemini_cli,codex_cli
--org-id <id>            -> __PHX_ORG_ID__
--workspace-id <id>      -> __PHX_WORKSPACE_ID__
--mode <M>               ADVISORY|GATE|BLOCK -> __PHX_POLICY_MODE__
--blocking-severities    JSON array -> __PHX_POLICY_BLOCKING_SEVERITIES__
--commit-domains         JSON array -> __PHX_POLICY_COMMIT_DOMAINS__
--push-domains           JSON array -> __PHX_POLICY_PUSH_DOMAINS__
--api-base <url>         overrides the baked API base
--dry-run                print every change, write nothing
--uninstall              remove exactly what was installed
```

Guardrail placement:

| Platform | Auto-detected by | Source | Destination |
|---|---|---|---|
| `claude_code` | `.claude/` | `guardrails/claude_code/.claude/rules/*.md` | `.claude/rules/` |
| `cursor` | `.cursor/` | `guardrails/cursor/.cursor/rules/*.mdc` | `.cursor/rules/` |
| `gemini_cli` | `GEMINI.md` or `.gemini/` | `guardrails/gemini_cli/security/*.md` | `.gemini/security/` |
| `codex_cli` | `AGENTS.md` | `guardrails/codex_cli/AGENTS.md` | appended to `AGENTS.md` |

Enforcement hook, `claude_code` only:

1. `scripts/purplephx-gate.sh` — copied, 6 placeholders substituted, `chmod 755`.
2. `.claude/rules/purple-scan-enforcement.md` — copied.
3. `CLAUDE.md` — enforcement block appended inside markers.
4. `.claude/settings.json` — `PreToolUse` entries merged via `jq`; `.bak` written first.
5. `.gitignore` — `.purplephx/receipts/` and `.purplephx/skips/` added.

Idempotency: every appended block is fenced by
`PHX-GUARDRAIL-START` / `PHX-GUARDRAIL-END` markers, and the `jq` merge first
drops any existing `PreToolUse` entry whose command mentions `purplephx-gate.sh`.
Re-running replaces rather than duplicates.

### 2. `guardrail-enforcement/demo/demo-guardrail-enforcement.sh`

`--mode live` (default) or `--mode mock`. Nine steps, each pausing for a keypress:

1. Build a throwaway git repo with a vulnerable file (`innerHTML` XSS + a hardcoded secret).
2. BEFORE: `git commit` succeeds. Nothing protects this repo.
3. Run the installer against it.
4. Show every installed file.
5. AFTER: pipe the `PreToolUse` payload into the gate. Exit `2` = blocked.
6. Fix the vulnerable line.
7. Re-run the gate. Exit `0` = allowed.
8. `cat ~/.phoenix/enforcement-policy/gate.log` — the audit trail.
9. Clean up, and print the command to open a real Claude Code session.

### 3. `guardrail-enforcement/demo/mock-phoenix-api.py`

Python 3 `http.server`. Six endpoints:

```
GET  /api/v1/external/purplephx/enforcement-policy     -> {mode, blockingSeverities, commitDomains, pushDomains, updatedAt}
POST /api/v1/external/pr-scan/resolve                  -> {bundles:[...]}
POST /api/v1/external/pr-scan/execute                  -> {jobId}
GET  /api/v1/external/pr-scan/{id}                     -> {status:"COMPLETED", domainResults:{...}}
GET  /api/v1/external/pr-scan/{id}/sarif               -> SARIF, 1 CRITICAL finding
POST /api/v1/external/purplephx/enforcement-violation  -> 200
```

Python, not bash+`nc`: BSD `nc` on macOS cannot hold a persistent HTTP loop reliably.

Two constraints the gate imposes on the mock, both load-bearing:

- Severity is read from `runs[].tool.driver.rules[ruleIndex].properties.severity`,
  never from SARIF `level`. The mock must emit the rule entry.
- A finding is NEW only if its `uri` is in `changedFiles` **and** its `startLine`
  falls inside a `git diff -U0` hunk. The mock reads `MOCK_FINDING_PATH` and
  `MOCK_FINDING_LINE` so the demo can point it at the real changed line.

### 4. Token handling in mock mode

The gate skips when `PHX_API_TOKEN` is unset, and refuses any token outside
`[A-Za-z0-9._-]`. Mock mode therefore exports a syntactically valid dummy token.
The gate also refuses `PHX_API_BASE` if it is declared in project-tracked files,
so mock mode passes the base in via the **baked** value (`--api-base`), not via
`.claude/settings.json`.

## Verification

Run the demo in `mock` mode end to end and record two exit codes:
`2` on the vulnerable commit, `0` after the fix. A skip is not a pass — the gate
log line must read `"verdict":"deny"`, not `"verdict":"skip"`.

## Known limits

- The demo drives the gate directly. It is the same contract Claude Code uses
  (stdin JSON, exit code), but it is not a live model session.
- Mock findings are canned. Mock mode proves the *mechanism*, never the scanner.
- Layer B is removable by the developer. Only layer C survives them.
