---
description: NEW_THREAT guard — auto-generated from Phoenix finding e65ac753-bcb0-4083-b7c2-9aaeecb0b66f
alwaysApply: false
globs: ["src/main/resources/static/templates/PathTraversal/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding e65ac753-bcb0-4083-b7c2-9aaeecb0b66f (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("Information").innerHTML = tableInformation;
```

## Evidence
e65ac753-bcb0-4083-b7c2-9aaeecb0b66f: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
