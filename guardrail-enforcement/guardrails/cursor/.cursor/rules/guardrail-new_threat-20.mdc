---
description: NEW_THREAT guard — auto-generated from Phoenix finding b12a33f3-2056-4fd8-8563-2509a4b93659
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/keys/**/*.pem"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding b12a33f3-2056-4fd8-8563-2509a4b93659 (2026-08-02)

# DO:
```pem
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-private-key
```

# DON'T:
```pem
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDG86CoStCZbgTi
```

## Evidence
b12a33f3-2056-4fd8-8563-2509a4b93659: Private Key detected. This is a sensitive credential and should not be hardcoded here. Instead, store this in a separate — Severity: HIGH, Type: NEW_THREAT
