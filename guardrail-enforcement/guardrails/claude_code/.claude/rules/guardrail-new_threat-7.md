---
description: NEW_THREAT guard — auto-generated from Phoenix finding 4b28020f-315c-4edb-b963-7255b9de8eeb
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 4b28020f-315c-4edb-b963-7255b9de8eeb (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  otherElement.innerHTML = otherComments;
```

## Evidence
4b28020f-315c-4edb-b963-7255b9de8eeb: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
