---
description: NEW_THREAT guard — auto-generated from Phoenix finding ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  isbnElement.innerHTML = isbn;
```

## Evidence
ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
