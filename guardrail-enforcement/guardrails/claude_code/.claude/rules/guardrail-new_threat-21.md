---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5350d0a8-9561-492b-b923-cfa5a51f88b7
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/LEVEL_7/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5350d0a8-9561-492b-b923-cfa5a51f88b7 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("jwt").innerHTML = data.content;
```

## Evidence
5350d0a8-9561-492b-b923-cfa5a51f88b7: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
