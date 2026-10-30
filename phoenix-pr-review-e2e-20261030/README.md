# Phoenix PR Review E2E fixture — 2026-10-30

**TEST ONLY — do not merge, build, deploy, or apply.** These files exist only to
exercise the Phoenix PR Review on POC1. They are outside the application's source
tree and are not imported by the running VulnerableApp.

| Domain | File | Intended signal |
| --- | --- | --- |
| SAST / AI-SAST | `unsafe_inputs.py` | Shell command injection, unsafe `eval`, unsafe YAML parsing |
| IaC | `main.tf` | Public SSH ingress and public S3 access |
| SCA | `requirements.txt` | Intentionally old Python dependencies |
| Container | `Dockerfile` | Old base image and root user |
| Secrets | `synthetic_secret.txt` | Public, synthetic AWS documentation credential pair |

All credentials in this fixture are **public synthetic examples**, not live
credentials. The Secret file is intentionally readable by scanners. Scanner
availability, policy, consent, budget, and PR-review enrollment determine which
domains actually run; a finding is not guaranteed merely because a fixture exists.

The PR should remain open only for testing and should be closed without merging.
