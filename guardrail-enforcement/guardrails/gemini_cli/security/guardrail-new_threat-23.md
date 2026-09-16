---
description: NEW_THREAT guard — auto-generated from Phoenix finding c017f742-4eab-4a4a-9710-832e5ebac1ce
alwaysApply: false
globs: ["src/main/resources/static/templates/ErrorBasedSQLInjectionVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c017f742-4eab-4a4a-9710-832e5ebac1ce (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("carInformation").innerHTML =
      "<img src='" + data.carInformation.imagePath + "' width='900'/>";
```

## Evidence
c017f742-4eab-4a4a-9710-832e5ebac1ce: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
