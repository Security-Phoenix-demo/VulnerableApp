---
description: NEW_THREAT guard — auto-generated from Phoenix finding 61508655-3a7e-4220-a5e0-0c57834bb18e
alwaysApply: false
globs: ["src/main/resources/static/templates/UnrestrictedFileUpload/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 61508655-3a7e-4220-a5e0-0c57834bb18e (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("uploaded_file_info").innerHTML = data.isValid
    ? "File uploaded at location:" + data.content
    : data.content;
```

## Evidence
61508655-3a7e-4220-a5e0-0c57834bb18e: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
