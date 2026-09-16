# Phoenix Correlation Test Bed — Detectable, Chainable Fixtures

**What this is:** intentionally vulnerable fixture files whose only purpose is to be **discovered by
a scanner** and then **chained by the Phoenix correlation engine into a toxic combination**. Nothing
here is wired into VulnerableApp's application logic, and nothing here is deployable.

**Read this before adding, moving, or "fixing" anything in this directory.** Several fixtures depend
on the *absence* of a resource elsewhere in the repository, and several are deliberately named so
that build tooling ignores them.

---

## Why this exists

The correlation engine had no corpus that exercised it. A run over a fully-scanned real workspace
returned **zero combinations** — not because the engine was broken, but because every join key its
edge verifiers need was 0% populated on real scan data. An empty result from a working engine and an
empty result from a broken one are indistinguishable.

The analyzer repo has a *synthetic* test bed (SQL-seeded rows, `docs/operations/vulns/`). This
directory is the other half: **real files, really scanned**, so the detection path in front of the
engine is exercised too rather than bypassed.

## Ground rules for this directory

| Rule | Why |
|---|---|
| Every credential is **synthetic with zero entropy** — AWS's own published documentation examples, or alphabet sequences | Recognisable as fake at a glance, and never a real leak |
| **No `pragma: allowlist secret`, no split literals** | See the note below — deliberate, not an oversight |
| Nothing is executable, nothing is deployable | These are scan targets, not infrastructure |
| Java fixtures live **outside `src/`** | Gradle's default sourceSet never compiles them, so the app's build and shipped artifact are unchanged |
| `pom-vulnerable.xml`, `Dockerfile.insecure` — **non-default names** | A real `pom.xml`/`Dockerfile` here would be picked up by Maven-aware tooling and by the SBOM generator's `mvn` probe as a genuine module |

### The deliberate departure on secret hygiene

The analyzer repo's `.claude/rules/test-fixture-secret-hygiene.md` asks for a
`pragma: allowlist secret` comment (or a split literal) above any synthetic credential, so that
credential-format fixtures don't pollute CI signal.

**These fixtures deliberately omit that**, because their entire purpose is the opposite: they *must*
be detected by the secret scanner, or they cannot seed a correlation. The rule's substantive
requirement — synthetic values with no real entropy — is honoured in full; only its suppression half
is omitted, and only here.

If this directory's findings become noisy in CI, exclude the whole `phoenix-testbed/` path at the
scanner-config level. **Do not** add pragmas or split the literals: that silently switches the test
bed off while leaving it looking intact.

---

## What is here

```
phoenix-testbed/
├── iac/terraform/
│   ├── 01-s3-public-unlogged.tf            PHX-IAC-COMB-002 + edge C (Secret <-> IaC)
│   ├── 02-iam-wildcard-apigw-no-waf.tf     PHX-IAC-COMB-003 + PHX-IAC-COMB-006
│   └── 03-rds-public-open-sg.tf            PHX-IAC-COMB-007
├── iac/kubernetes/
│   ├── 04-privileged-pod-loadbalancer.yaml PHX-IAC-COMB-001  (partial — see below)
│   ├── 05-hostnetwork-hostpath-root.yaml   PHX-IAC-COMB-005  (partial — see below)
│   └── 06-clusteradmin-binding.yaml        PHX-IAC-COMB-008
├── code/
│   ├── SqlInjectionSink.java               CWE-89  — edge A chain material
│   ├── CommandInjectionSink.java           CWE-78  — edge A, incl. the CONFIRMED path
│   └── SsrfSink.java                       CWE-918 — edge A
├── sca/pom-vulnerable.xml                  5 real CVEs (cannot chain — see below)
└── container/Dockerfile.insecure           CONTAINER findings + baked credentials
```

## Expected outcomes, honestly split

### Expected to FIRE

| Fixture | Rule / edge | Mechanism |
|---|---|---|
| `01-s3-public-unlogged.tf` | **PHX-IAC-COMB-002** | `tags.backup_access_key` seeds a `LITERAL_CREDENTIAL` taint origin *in the bucket itself*; `acl = "public-read"` makes it a `PHX-IAC-SINK-PUBLIC-S3` sink; no `aws_s3_bucket_logging` exists |
| `01-s3-public-unlogged.tf` | **edge C** (Secret ↔ IaC) | Secret and IaC asset are in the **same file** — which is what `AssetChainEdgeVerifier` resolves against. Needs `phx.correlation.edge-asset-chain-enabled=true` (default **false**) |
| `02-iam-wildcard-apigw-no-waf.tf` | **PHX-IAC-COMB-003** | Compact-JSON `"Action":"*"` on an `aws_iam_policy` |
| `02-iam-wildcard-apigw-no-waf.tf` | **PHX-IAC-COMB-006** | Same wildcard + an `aws_api_gateway_rest_api`, and no `aws_wafv2_web_acl` |
| `03-rds-public-open-sg.tf` | **PHX-IAC-COMB-007** | Top-level `publicly_accessible = true` + a `0.0.0.0/0` SG the db **references** (the reference is what makes the SG reachable in the taint BFS) |
| `06-clusteradmin-binding.yaml` | **PHX-IAC-COMB-008** | `cluster-admin` matched by the **keyless** propertyMatch form, which is nesting-agnostic |
| All `code/*.java` | **HUNT findings with a CWE** | The LLM hunt pass assigns a CWE per finding, and CWE is edge A's join key |
| `Dockerfile.insecure`, all fixtures | SECRET / CONTAINER / SAST findings | Detection only — see the caveats |

### Expected to be PARTIAL or NOT to chain — and why

| Fixture | What fails | Why it is the rule's limit, not the fixture's |
|---|---|---|
| `04-privileged-pod-loadbalancer.yaml` | COMB-001's `privileged=true` | The `key=value` propertyMatch form reads a **top-level** property key. In any valid manifest `privileged` sits at `spec.template.spec.containers[].securityContext.privileged`. No parseable Deployment can put it at the top level. The `PHX-IAC-SINK-K8S-LB` sink and the per-engine privileged-container findings still fire. |
| `05-hostnetwork-hostpath-root.yaml` | COMB-005's `hostPath=/` | Same top-level limitation. Note the asymmetry worth keeping: `usesHostNetwork()` **is** nesting-aware, so the sink fires while the rule's own propertyMatch cannot — the two disagree about one manifest. |
| `sca/pom-vulnerable.xml` | **Any** chain | Edge B is **structurally unreachable**: `mapScaCveRow` hardcodes `reachabilityDistance = null` and `sourceEndpoints = emptyList()`, and `ScaReachabilityEdgeVerifier` requires both. No manifest can satisfy it. Useful for proving SCA *detection*, and as the corpus half of a regression test for that defect. |
| `Dockerfile.insecure` | Edge C's container leg | No IaC asset parser ever emits an image reference as a `resourceAddress`, so a CONTAINER row's image ref has nothing to match. |
| `code/*.java` | **SAST**-sourced edge A | SAST's CWE is derived by a `/(?i)(CWE-\d+)/` regex over the **rule id**, not from a column — and no semgrep rule id in this repo carries a CWE token. A SAST hit here has `cwe = null` and cannot satisfy edge A. HUNT is the working code side. |
| Every `code/*.java` chain | Edge A needs a **DAST peer** | Edge A joins a code finding to a **live** finding. That requires a running instance and a DAST assessment — no file can produce it. |

### Absences that are load-bearing

Four rules match on a resource type being **absent**. Adding any of these anywhere in this
repository silently switches its rule off:

- `aws_s3_bucket_logging` → kills COMB-002
- `aws_wafv2_web_acl` → kills COMB-006
- `NetworkPolicy` → kills COMB-001
- `PodSecurityPolicy` → kills COMB-008

---

## How to run it

1. **Onboard/rescan this repo** in Phoenix so the IaC, secret, SCA and container scanners populate
   findings, and the IaC scan writes asset nodes into the graph. The `PHX-IAC-*` rules match via a
   graph query (`toxicComboResolve`) against those assets — no assets, no rule matches, regardless
   of what the files contain.
2. **Run a HUNT pass** if you want the code-side CWEs that edge A joins on.
3. **Enable correlation and run it:**
   ```
   PHX_CORRELATION_ENABLED=true
   PHX_CORRELATION_EDGE_ASSET_CHAIN_ENABLED=true    # only for edge C
   ```
   Correlation has no REST trigger; enqueue a `QUEUED` row in `correlation_job` (tier `FAST`).
4. **Read the results** and compare against the tables above.

Full runbook, the synthetic SQL-seeded companion test bed, and the observed results of the first
live FAST run are in the analyzer repo at `docs/operations/vulns/README.md`.

## Known gaps

- **CONFIRMED — no scan has been run against these files yet.** Every "expected to fire" row above
  is derived from reading `IacTaintService`, `IacToxicCombinationEngine` and the correlation
  verifiers directly, not from an observed detection. The mechanisms are precise (exact predicates,
  exact property paths); whether each scanner's parser populates the properties those predicates
  read is **unverified**.
- **CONFIRMED — the two PARTIAL Kubernetes rules were not empirically confirmed to fail**, only
  shown to be unsatisfiable by reading the matching code. If a future parser flattens nested
  properties, they would begin to fire.
- **PARTIAL — edge C needs graph asset nodes in the secret's own file.** Whether
  `buildFileToAssets` resolves `aws_s3_bucket.phx_testbed_public_data` from
  `01-s3-public-unlogged.tf` depends on the Terraform parser's output, which was not inspected.
- **The IaC combination rules are repository-wide, not directory-scoped.** They match over all
  assets for a repo, so a fixture here can be satisfied — or broken — by a resource anywhere else in
  VulnerableApp. The pre-existing `terraform/main.tf` already contributes a provider credential and
  an S3 bucket to the same asset set.
