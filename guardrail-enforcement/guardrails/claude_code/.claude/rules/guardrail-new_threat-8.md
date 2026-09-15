---
description: NEW_THREAT guard — auto-generated from Phoenix finding a501b04d-ecef-4019-91c5-42ec2b944a37
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a501b04d-ecef-4019-91c5-42ec2b944a37 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  publisherElement.innerHTML = publisher;
```

## Evidence
a501b04d-ecef-4019-91c5-42ec2b944a37: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
