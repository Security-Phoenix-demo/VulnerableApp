---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2a0fa72e-5a9c-4b03-8428-456a83626ecb
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/LEVEL_7/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2a0fa72e-5a9c-4b03-8428-456a83626ecb (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("verificationResponse").innerHTML =
      "JWT: " + data.content + " is not valid. Please try again";
```

## Evidence
2a0fa72e-5a9c-4b03-8428-456a83626ecb: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT
