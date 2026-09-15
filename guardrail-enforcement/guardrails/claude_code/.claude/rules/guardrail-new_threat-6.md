---
description: NEW_THREAT guard — auto-generated from Phoenix finding a3cc3166-e29c-4bea-995b-c43c316b4892
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a3cc3166-e29c-4bea-995b-c43c316b4892 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("bookInformation").innerHTML = data;
```

## Evidence
a3cc3166-e29c-4bea-995b-c43c316b4892: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
