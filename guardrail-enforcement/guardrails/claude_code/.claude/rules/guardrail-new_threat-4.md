---
description: NEW_THREAT guard — auto-generated from Phoenix finding ddba1184-bd22-4c7b-b7f0-5ef5596002e1
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ddba1184-bd22-4c7b-b7f0-5ef5596002e1 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
      detailTitle.innerHTML = responseText;
```

## Evidence
ddba1184-bd22-4c7b-b7f0-5ef5596002e1: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
