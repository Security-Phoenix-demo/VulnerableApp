---
description: NEW_THREAT guard — auto-generated from Phoenix finding f490fdd9-b7d9-4415-970b-bae74e1961b2
alwaysApply: false
globs: ["src/main/resources/static/templates/UnionBasedSQLInjectionVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding f490fdd9-b7d9-4415-970b-bae74e1961b2 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("carInformation").innerHTML =
    "<img src='" + data.imagePath + "' width='900'/>";
```

## Evidence
f490fdd9-b7d9-4415-970b-bae74e1961b2: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
