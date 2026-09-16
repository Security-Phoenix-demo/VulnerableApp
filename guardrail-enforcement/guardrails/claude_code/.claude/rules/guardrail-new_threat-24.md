---
description: NEW_THREAT guard — auto-generated from Phoenix finding f5438e61-f414-4138-a1e8-1198f5a88577
alwaysApply: false
globs: ["src/main/resources/static/templates/CommandInjection/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding f5438e61-f414-4138-a1e8-1198f5a88577 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("pingUtilityResponse").innerHTML = data.content;
```

## Evidence
f5438e61-f414-4138-a1e8-1198f5a88577: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
