# Phoenix PR review end-to-end fixture

These files are intentionally vulnerable, synthetic scan inputs for a single pull request.
They are outside the application source tree. Do not execute, build, deploy, or merge them.
No credentials in this directory are real. The fixtures exercise inline finding placement,
severity display, check summaries, and remediation suggestions in Phoenix PR Review.

Expected scanner signals depend on the enabled PR policy and scanner availability:

- `unsafe_inputs.py`: Python code injection and shell command injection (SAST).
- `open_ssh.tf`: unrestricted SSH ingress (IaC).
- `Dockerfile`: root container and missing health check (Container/IaC).
- `requirements.txt`: intentionally old dependencies (SCA, when the scanner
  scans the nested manifest).

This folder is a review fixture, not a runnable test suite. An absent finding is not proof
that the vulnerable pattern is safe; check scanner scope and PR policy first.
