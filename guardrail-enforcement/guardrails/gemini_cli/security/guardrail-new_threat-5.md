---
description: NEW_THREAT guard — auto-generated from Phoenix finding 498f139f-b27c-4dcd-a3aa-2426e4908881
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 498f139f-b27c-4dcd-a3aa-2426e4908881 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("vulnerabilityDescription").innerHTML =
      vulnerableAppEndPointData[id]["Description"];
```

## Evidence
498f139f-b27c-4dcd-a3aa-2426e4908881: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
