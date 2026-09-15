---
description: NEW_THREAT guard — auto-generated from Phoenix finding a50babcb-65c7-44e3-a2da-802817a99b6b
alwaysApply: false
globs: ["src/main/resources/static/templates/XSSWithHtmlTagInjection/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a50babcb-65c7-44e3-a2da-802817a99b6b (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-document-method
```

# DON'T:
```javascript
  parentContainer.innerHTML = data;
```

## Evidence
a50babcb-65c7-44e3-a2da-802817a99b6b: User controlled data in methods like 'innerHTML', 'outerHTML' or 'document.write' is an anti-pattern that can lead to XS — Severity: HIGH, Type: NEW_THREAT
