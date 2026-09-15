# Phoenix Security — Graph Navigation for Coding Agents

You have a Phoenix Security MCP server configured in `.mcp.json` under the client-facing key `purplephx`.
Before grepping blindly, navigate this repository through its pre-built code graph.

Set `tenant_id` before calling compatibility graph or scan tools. In local dev, use the org UUID from the running Phoenix session; in prod/demo, use the authenticated org/tenant claim supplied by Phoenix.

## When to use the graph
- "Where is X defined / who calls it?" -> graph, not text search.
- Impact / blast-radius before editing -> graph.
- Understanding entry points or unfamiliar areas -> graph.

## Available MCP tools (use these exact names)
| Tool | Use |
|---|---|
| `list_repos` | Confirm which repos are indexed: `{ "tenant_id" }`. |
| `analyze_repository` | Index/refresh a repo graph: `{ "repoPath": "/abs/path" }`. |
| `query_graph` | Find a symbol: `{ "repoName", "tenant_id", "query", "limit" }`. |
| `get_call_chain` | Context around a symbol: `{ "repoName", "tenant_id", "symbolId" }`. |
| `get_entry_points` | List entry points: `{ "repoName", "tenant_id", "limit" }`. |
| `detect_changes` | Map a git diff to graph symbols: `{ "repoName", "tenant_id", "oldSha", "newSha" }`. |
| `rename` | Preview-only rename impact: `{ "repoName", "tenant_id", "symbolId", "newName" }`. |

## Scan tools
| Tool | Use |
|---|---|
| `scan_all` | Run selected bundle: `{ "repoName", "tenant_id", "include", "dry_run" }`. Add `"dry_run": true` first. |
| `scan_sast` / `scan_sca` / `scan_secret` / `scan_container` / `scan_iac` | Focused scans; include `tenant_id`. |
| `run_assessment` | OWASP/ASVS assessment; include `tenant_id`. |
| `run_hunt` | Exploit Hunt; include `tenant_id` and run only on explicit user request. |
| `run_prometheus` | Prometheus reasoner (cost-bearing, needs `tenant_id` - explicit request only). |

## Session hook profiles
SessionStart and SessionEnd hooks are optional and user-configured through `.purplephx/session.env`.
Supported SessionEnd profiles: `GRAPH_ONLY`, `STANDARD_ASSESSMENT`, `AI_VALIDATION`, `HUNT_FAST`, `HUNT_DEEP`, `PROMETHEUS`.
When SessionEnd is enabled in `block` mode, the hook must not exit until graph analysis and the selected profile have reached terminal status.

## Recommended flow
1. `list_repos` with `tenant_id` -> confirm the repo is indexed.
2. `query_graph` with `tenant_id` to locate the symbol you're changing.
3. `get_call_chain` + `rename` (preview) to understand blast radius before editing.
4. After changes, `scan_all` (dry-run, then real) to validate security posture.

## Notes
- Compatibility graph/scan tools require `tenant_id` for strict tenant scoping.
- Hunt and Prometheus cost money or LLM tokens; never run them automatically.
- The client-facing editor key is `purplephx`; runtime resources and backend contracts remain Phoenix-backed.
