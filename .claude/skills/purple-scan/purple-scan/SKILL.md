---
name: purple-scan
description: Unified Phoenix Purple security scanning skill — PR scan + AI validation (scan-assess), 0-day exploit hunt, or Prometheus surface probe — results and remediation surfaced here via MCP tools or REST fallback.
trigger: "purple scan", "scan-assess", "scan pr", "hunt vulnerabilities", "prometheus probe", "0-day hunt", "purple assess", "/purple-scan"
---

# Purple Scan Skill

## Purpose

Run Phoenix Purple security scanning and surface findings + remediation in this conversation.

| Mode | Trigger | Primary path |
|------|---------|-------------|
| **hunt** | "hunt", "0-day", "exploit hunt" | MCP: `exploit_hunt_run` → `exploit_hunt_status` |
| **prometheus** | "prometheus", "surface probe", "promytheus" | MCP: `prometheus_probe` → `prometheus_get_run` |
| **scan-assess** | "scan PR", "assess PR", "scan-assess" | REST: resolve → execute → poll (no MCP tool yet) |

---

## Step 0 — Detect MCP vs REST

**Check MCP first.** The Phoenix MCP server exposes all graph and security tools directly — no JWT, no curl, no environment setup needed when it is connected.

```
MCP server configured?  →  use MCP tool calls (Steps 2A/2B below)
MCP not configured?     →  fall back to REST+curl (Step 3 below)
```

To check: call `tools/list` or try reading `phx://repos/catalog`. If it returns data, MCP is live.

---

## Step 1 — Resolve Target Repo

Check in this order — stop as soon as one resolves:

1. Explicit in user message (e.g. "hunt in `VulnerableApp`")
2. Earlier in this conversation (repo name already established)
3. Via MCP: read `phx://repos/catalog` and present the list
4. Via REST: `GET /api/workspaces` → show repo list
5. Ask the user

For `scan-assess` also resolve `baseBranch` (default `main`) and `headBranch`.

---

## Step 2A — Exploit Hunt via MCP

### Seed + start in one call

```
tool: exploit_hunt_run
args:
  repository: "<repoName>"
  max_targets: 20          # increase for deep scan
  budget_usd: 5.00
```

Returns: `huntRunId`, `status`, `totalTargets seeded`

### Poll status

```
tool: exploit_hunt_status
args:
  hunt_run_id: "<huntRunId>"
```

Poll every 10–15 s until `status` is `COMPLETE` or `FAILED`.
Report progress: `processedTargets / totalTargets`, `confirmedFindings`, `cost so far`.

### If you need graph context before hunting

Use the graph tools first to understand attack surface, then seed:

```
tool: entry_points
args: { repoName: "<repoName>" }

tool: key_functions
args: { repoName: "<repoName>" }
```

Feed interesting file paths from those results as context when presenting the hunt configuration.

---

## Step 2B — Prometheus Probe via MCP

Prometheus requires a `tenant_id`. For local dev, use the dev user ID (`dev-superadmin`, `dev-admin`, or `dev-user` from `application-local.yml`). For prod/demo, the tenant_id comes from the user's JWT subject claim.

```
tool: prometheus_probe
args:
  tenant_id: "<tenantId>"
  repo_name: "<repoName>"
  scope: "full"
  budget_usd: 2.00
  max_loops: 8
  surface_filter: "<optional — e.g. 'injection'>"
```

Returns: `run_id`, `status`, `hypothesis_tree_summary`, `top_hypotheses[3]`, `top_results[3]`, `cost_used_usd`, `source_of_defaults`

### Poll for results

```
tool: prometheus_get_run
args:
  tenant_id: "<tenantId>"
  run_id: "<runId>"
```

Poll every 15 s until `status` is `COMPLETED` or `FAILED` or `CANCELLED`.
Report each poll: iteration, active hypotheses, cost.

### To cancel

```
tool: prometheus_cancel_run
args:
  tenant_id: "<tenantId>"
  run_id: "<runId>"
```

---

## Step 2C — Graph-Backed Security Questions (MCP)

For security-specific questions against the graph, use these tools directly without starting a hunt or probe:

**"Who are the entry points and what's the blast radius of X?"**
```
tool: entry_points
args: { repoName: "<repoName>" }

tool: impact
args: { repoName: "<repoName>", symbolId: "<functionName>" }
```

**"What are the taint paths / high-risk functions?"**
```
tool: key_functions
args: { repoName: "<repoName>" }

tool: processes
args: { repoName: "<repoName>" }
```

**"What calls this authentication function?"**
```
tool: context
args: { repoName: "<repoName>", symbolName: "<functionName>" }
```

**"Give me a security overview of this repo"**
```
tool: overview
args: { repoName: "<repoName>" }
```

Read `phx://repo/{repoName}/entry-points` and `phx://repo/{repoName}/processes` for richer structured data.

---

## Step 3 — REST Fallback (when MCP not configured)

### Auth resolution (smart — check before asking)

| What you need | Check order |
|--------------|-------------|
| Base URL | `$PURPLE_BASE_URL` → `$PHX_BASE_URL` → infer from "local"/"demo"/"prod" in user message → default prod |
| JWT | `$PURPLE_JWT` → `$PHX_JWT` → local: tell user to copy from browser → ask |
| LLM key (AI modes only) | `$PHX_LLM_API_KEY` (server-side, skip header) → `$OPENAI_API_KEY` → `$ANTHROPIC_API_KEY` → ask |

For **local dev**, `$PHX_LLM_API_KEY` is set in `docker-compose.dev.yml` — no BYOK header needed.

### PR Scan (scan-assess) — REST only

```bash
# 1. Resolve bundles
RESOLVE=$(curl -s -X POST "${BASE}/api/v1/pr-scan/resolve" \
  -H "Authorization: Bearer ${JWT}" \
  -H "Content-Type: application/json" \
  -d '{"repoName":"<repo>","workspaceId":"<wsId>"}')

# 2. Execute (add x-llm-api-key only for AI tiers)
JOB=$(curl -s -X POST "${BASE}/api/v1/pr-scan/execute" \
  -H "Authorization: Bearer ${JWT}" \
  ${LLM_API_KEY:+-H "x-llm-api-key: ${LLM_API_KEY}"} \
  -H "Content-Type: application/json" \
  -d '{
    "repoName":"<repo>",
    "baseBranch":"<base>",
    "headBranch":"<head>",
    "resolvedBundles":'"$(echo $RESOLVE | jq '.resolvedBundles')"',
    "timeoutSeconds":300
  }')

JOB_ID=$(echo $JOB | jq -r '.jobId')

# 3. Poll
while true; do
  S=$(curl -s "${BASE}/api/v1/pr-scan/${JOB_ID}" -H "Authorization: Bearer ${JWT}" | jq -r '.status')
  [[ "$S" == "COMPLETE" || "$S" == "FAILED" || "$S" == "BLOCKED" ]] && break
  sleep 5
done

# 4. Fetch SARIF
curl -s "${BASE}/api/v1/pr-scan/${JOB_ID}/sarif" -H "Authorization: Bearer ${JWT}"
```

### Hunt via REST (alternative to MCP)

```bash
HUNT=$(curl -s -X POST "${BASE}/api/ctf-hunt/start" \
  -H "Authorization: Bearer ${JWT}" \
  ${LLM_API_KEY:+-H "x-llm-api-key: ${LLM_API_KEY}"} \
  -H "Content-Type: application/json" \
  -d '{"repoName":"<repo>","budget":5.00,"maxFiles":20,"mode":"NORMAL"}')

RUN_ID=$(echo $HUNT | jq -r '.runId')
STREAM_SECRET=$(echo $HUNT | jq -r '.streamSecret')

# Stream (background)
curl -sN "${BASE}/api/ctf-hunt/stream/${RUN_ID}?stream_secret=${STREAM_SECRET}" \
  -H "Authorization: Bearer ${JWT}" &

# Collect results + fix patches
RESULTS=$(curl -s "${BASE}/api/ctf-hunt/results/${RUN_ID}" -H "Authorization: Bearer ${JWT}")
for ID in $(echo $RESULTS | jq -r '.exploits[] | select(.verdict=="CONFIRMED") | .id'); do
  curl -s "${BASE}/api/risks/exploits/${ID}/detail" -H "Authorization: Bearer ${JWT}" \
    | jq '{title, cwe, severity, fixPatch, proofOfConcept}'
done
```

---

## Step 4 — Present Results

### Hunt results

```
## Exploit Hunt — {repoName}

Confirmed: {n} exploits  |  Cost: ${costUsd}  |  Files: {n} scanned
Pass breakdown: HUNT {n} → JUDGE confirmed {n} → VERIFY exploitable {n}

### Confirmed #{n} — {title} ({severity}, {cwe})
- File: {filePath}:{line}
- Judge: CONFIRMED — confidence {pct}%, feasibility {HIGH|MEDIUM|LOW}
- PoC: `{proofOfConcept}`
- Remediation: {suggestedFix}

Fix patch:
```diff
{fixPatch}
```
```

### Prometheus results

```
## Prometheus Probe — {repoName}

Status: {status}  |  Loops: {n}/{max}  |  Cost: ${costUsd}
Hypotheses: {total} generated, {confirmed} confirmed

### Hypothesis #{n} — {claim} ({cwe}, confidence {pct}%)
- Surface: {surface}
- Evidence: {evidenceSummary}
- Attack path: {attackPath}
- Remediation hint: {remediationHint}
```

### scan-assess results

```
## PR Scan — {headBranch} → {baseBranch}

Verdict: PASS | WARN | BLOCK
Tiers: {list}  |  Graph: fresh | ⚠ stale

| # | Severity | CWE | Rule | File:Line | AI-validated |
|---|----------|-----|------|-----------|--------------|

### Critical — {cwe}: {ruleId}
- File: {filePath}:{line}
- Why exploitable: {aiRationale}
- Remediation: {suggestedFix}
```

---

## Step 5 — Follow-up offers

```
Next steps:
1. Re-run in DEEP mode for full PoC verification (Hunt)
2. Hand Prometheus hypotheses to Exploit Hunt for PoC confirmation
3. Apply fix patches (Hunt confirmed exploits)
4. Export SARIF to GitHub Security tab (scan-assess)
5. Ask a graph question: "who calls {function}?" or "blast radius of {symbol}?"
6. Set up scheduled weekly hunt
```

---

## MCP tool quick reference

| Tool | Purpose | Key args |
|------|---------|----------|
| `analyze` | Build/refresh graph | `repoPath`, `repoName` |
| `query` | Find symbols by name | `repoName`, `pattern` |
| `context` | Callers + callees of a symbol | `repoName`, `symbolName` |
| `impact` | Blast radius of a symbol | `repoName`, `symbolId` |
| `entry_points` | PageRank entry points | `repoName` |
| `key_functions` | Top functions by importance | `repoName` |
| `processes` | Execution flows | `repoName` |
| `overview` | Full graph snapshot summary | `repoName` |
| `exploit_hunt_seed` | Seed targets only | `repository`, `max_targets`, `budget_usd` |
| `exploit_hunt_run` | Seed + start hunt | `repository`, `max_targets`, `budget_usd` |
| `exploit_hunt_status` | Poll hunt progress | `hunt_run_id` |
| `exploit_hunt_ingest` | Ingest findings into a run | `hunt_run_id`, `findings[]` |
| `prometheus_probe` | Start Prometheus probe | `tenant_id`, `repo_name`, `budget_usd`, `max_loops` |
| `prometheus_get_run` | Get run + hypotheses | `tenant_id`, `run_id` |
| `prometheus_cancel_run` | Cancel a probe | `tenant_id`, `run_id` |

**Feature gates:**
- Hunt tools hidden when `phx.ctfhunt.api-enabled=false`
- Prometheus tools absent when `features.prometheus=false`

---

## Error handling

| Error | Cause | Resolution |
|-------|-------|------------|
| MCP tool missing from `tools/list` | Feature flag off or wrong runtime | Check `PHX_CTFHUNT_API_ENABLED` / `FEATURES_PROMETHEUS` |
| `tenant_id required` (Prometheus MCP) | Missing arg | Pass dev user ID for local; JWT subject for prod |
| `401 Unauthorized` (REST) | JWT expired | Re-export `PURPLE_JWT` from browser |
| `403` on SSE stream (REST) | Missing `stream_secret` | Re-read from start-run response |
| `graphStale: true` | Graph outdated | Call `analyze` tool (MCP) or `POST /api/analyze/start` (REST) |
| Hunt `FAILED` | Budget or worker error | Reduce `max_targets`, increase `budget_usd`, check `failureReason` |
| Prometheus `429` | Concurrency cap (5/tenant) | Wait for `Retry-After` |
