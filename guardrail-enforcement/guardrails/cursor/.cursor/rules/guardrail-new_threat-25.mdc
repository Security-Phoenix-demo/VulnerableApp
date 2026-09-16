---
description: NEW_THREAT guard — auto-generated from Phoenix finding 260747c4-06df-4a8b-9d1e-51d16e5ffcc8
alwaysApply: false
globs: ["src/main/resources/sampleVulnerability/staticResources/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 260747c4-06df-4a8b-9d1e-51d16e5ffcc8 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("response").innerHTML = data.content;
```

## Evidence
260747c4-06df-4a8b-9d1e-51d16e5ffcc8: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
