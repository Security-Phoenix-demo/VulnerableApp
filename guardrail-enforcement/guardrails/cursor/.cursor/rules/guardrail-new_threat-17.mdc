---
description: NEW_THREAT guard — auto-generated from Phoenix finding 8c9a5110-003a-419d-a7af-699660885e6c
alwaysApply: false
globs: ["src/main/resources/static/templates/PersistentXSSInHTMLTagVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 8c9a5110-003a-419d-a7af-699660885e6c (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("allPosts").innerHTML = data;
```

## Evidence
8c9a5110-003a-419d-a7af-699660885e6c: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
