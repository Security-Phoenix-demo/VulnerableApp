---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  bookNameElement.innerHTML = bookName;
```

## Evidence
5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
