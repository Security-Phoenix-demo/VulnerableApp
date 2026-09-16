---
name: purple-graph-navigator
description: Use Phoenix Purple Graph as a code knowledge graph for function-level navigation, call-chain tracing, entry-point mapping, process/community context, impact analysis, and graph-backed security evidence.
trigger: "purple graph", "function navigation", "function-level navigation", "navigate function", "call chain", "who calls this", "knowledge graph", "/purple-graph"
---

# Purple Graph Navigator

## Purpose

Use Phoenix Purple Graph to move from a human function name, file location, finding, or suspected code path to a graph-backed navigation report:

- exact symbol identity and source location
- direct callers and callees
- entry-point reachability and process membership
- related community/module context
- upstream blast radius and downstream dependencies
- security evidence to reuse in scans, reviews, or remediation

Use this skill for exploration and navigation. Use `purple-scan` when the user wants PR scanning, Exploit Hunt, Prometheus, or remediation output.

## Prerequisites

Confirm the target repository is indexed before deep navigation:

1. Read `phx://repos/catalog`.
2. If the repo is absent or shows `freshness=stale_missing_path` or `freshness=stale_path_not_found`, run `analyze` with `repoPath`.
3. Read `phx://repo/{repoName}/context` and `phx://repo/{repoName}/schema`.

Do not infer call paths from source text alone when the graph is available. Use source reads only to confirm implementation details after graph navigation.

## Workflow

### 1. Resolve The Function

Start from the most precise handle the user supplied:

| Input | Resolution path |
|-------|-----------------|
| `symbolId` | Use it directly with `context` and `impact` |
| Function/method name | `query({repoName, query: "<name>", limit: 10})`, then disambiguate by file/type |
| File and line | Search source locally, then map the enclosing symbol with `query` or REST `/api/query/symbols/{repoName}` |
| Finding ID | Use finding-specific context first, then map finding file/line to a symbol |

If the MCP `query` response is formatted without IDs, recover the symbol ID through one of these current surfaces:

- REST: `GET /api/query/symbols/{repoName}?query=<name>&limit=10`
- MCP overview fallback: `overview({repoName})`, then filter `symbols[]` by `name`, `filePath`, `startLine`, and `endLine`

Never call `context` or `impact` with an unverified display name when the API expects `symbolId`.

### 2. Build The 360-Degree Function View

Use the current MCP tools in this order:

```text
resources/read phx://repos/catalog
resources/read phx://repo/{repoName}/context
query({repoName, query, limit: 10})
context({repoName, symbolId})
impact({repoName, symbolId, depth: 3})
entry_points({repoName, limit: 20})
processes({repoName})
communities({repoName})
```

Filter later results to the target function and its callers/callees. Keep the answer function-centered rather than dumping whole-repo output.

### 3. Classify Navigation Role

Classify the target function using graph evidence:

| Role | Evidence |
|------|----------|
| Entry point | Appears in `entry_points`, HTTP handler, CLI main, event handler, scheduler |
| Orchestrator | High callee count, process step fan-out, service coordination |
| Adapter | External service calls, repository/worker/client boundary |
| Validator/sanitizer | Called before sinks, validation/sanitize naming, security relation context |
| Sink | Database, file, command, template, deserialization, outbound request, credential use |
| Leaf/helper | Low caller/callee count, no process membership, local utility |

### 4. Produce A Navigation Report

Return this structure:

```text
## Function Navigation - {symbol.name}

Identity:
- Symbol ID: {symbolId}
- Type: {Function|Method|Class}
- File: {filePath}:{startLine}
- Signature: {signature if available}

Graph Position:
- Role: {entry point|orchestrator|adapter|validator|sink|leaf/helper}
- Direct callers: {count, top names}
- Direct callees: {count, top names}
- Processes: {process names or none}
- Community: {best matching community or none}

Reachability:
- Entry-point path: {known path or "not proven by graph"}
- Upstream impact: {risk level, direct affected count}
- Downstream dependencies: {important callees or external boundaries}

Security Context:
- Tainted/source/sink role if present
- Related findings or graph-backed evidence if supplied
- Missing evidence / graph gaps

Recommended Next Step:
- What to inspect, test, or scan next
```

## Security Questions via Graph

When the user asks a security question directly ("is this function reachable from the internet?", "what are the injection sinks?", "what user input reaches this query?"), answer it using graph evidence, not source-text inference.

**Question → tool mapping:**

| Question type | Tools to call |
|--------------|--------------|
| "Is X reachable from user input / the internet?" | `entry_points` → `impact` on X → check if X appears in a process starting from an entry point |
| "What are the injection sinks / dangerous callees?" | `key_functions` (high PageRank sinks) + `processes` (execution flows reaching external boundaries) |
| "What calls this authentication / crypto / session function?" | `context({symbolId})` → callers list |
| "Where does this user input end up?" | `query` to find the input handler → `impact` to trace downstream to sinks |
| "What's the blast radius if I change X?" | `impact({symbolId, depth: 3})` |
| "Which modules handle secrets / credentials?" | `communities` → identify community containing secret-handling code → `context` per symbol |
| "What's the attack surface of this service?" | `entry_points` + `processes` + `overview` |

For each answer: lead with the graph result, then interpret. Label any inferences not backed by graph data as "inferred — not confirmed by graph".

If Hunt or Prometheus evidence already exists for a symbol, surface it as "graph-backed finding" and refer the user to `/purple-scan` for full exploit verification.

## Guardrails

- Treat stale graph context as a blocker for confident navigation.
- Prefer `symbolId` over display names after resolution.
- Do not overstate reachability: say "not proven by graph" when no process or entry-point path is returned.
- Keep finding/evidence language aligned with Phoenix Purple Graph: graph-backed evidence first, inferred context clearly labeled.
- For security questions, separate graph evidence from LLM or manual inference.

## Related References

- Integration guide: `docs/ext-service-integrations/PURPLE_GRAPH_NAVIGATION.md`
- MCP feature doc: `docs/features/mcp-server.md`
- MCP contract: `code-analyzer-service/docs/MCP.md`
- Product overview: `docs/features/product-overview.md`
