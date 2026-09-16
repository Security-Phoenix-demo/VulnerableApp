---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389
alwaysApply: false
globs: ["src/main/resources/static/templates/PersistentXSSInHTMLTagVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  postDiv.innerHTML = post.content;
```

## Evidence
5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
