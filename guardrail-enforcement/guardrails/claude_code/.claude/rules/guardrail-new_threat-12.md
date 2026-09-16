---
description: NEW_THREAT guard — auto-generated from Phoenix finding 7d9e4726-35c1-4c78-8c10-fda499edae8f
alwaysApply: false
globs: ["src/main/resources/static/templates/XSSWithNullBytesImgTagAttribute/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 7d9e4726-35c1-4c78-8c10-fda499edae8f (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("image").innerHTML = data;
```

## Evidence
7d9e4726-35c1-4c78-8c10-fda499edae8f: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
