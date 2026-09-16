---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5ff5c55a-1c87-4bfc-b8db-37a6c90fc306
alwaysApply: false
globs: ["src/main/resources/static/templates/SSRFVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5ff5c55a-1c87-4bfc-b8db-37a6c90fc306 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("projectsResponse").innerHTML = tableInformation;
```

## Evidence
5ff5c55a-1c87-4bfc-b8db-37a6c90fc306: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
