---
description: NEW_THREAT guard — auto-generated from Phoenix finding 02e7c7d7-79fa-4d38-a3b4-de58f1b10b10
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 02e7c7d7-79fa-4d38-a3b4-de58f1b10b10 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-document-method
```

# DON'T:
```javascript
  span.innerHTML = isSecure ? variantTooltip.secure : variantTooltip.unsecure;
```

## Evidence
02e7c7d7-79fa-4d38-a3b4-de58f1b10b10: User controlled data in methods like 'innerHTML', 'outerHTML' or 'document.write' is an anti-pattern that can lead to XS — Severity: HIGH, Type: NEW_THREAT
