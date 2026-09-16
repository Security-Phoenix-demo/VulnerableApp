---
description: NEW_THREAT guard — auto-generated from Phoenix finding b99501ea-0855-4636-a47b-059e3e634395
alwaysApply: false
globs: ["src/main/resources/**/*.properties"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding b99501ea-0855-4636-a47b-059e3e634395 (2026-08-02)

# DO:
```properties
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-aws-access-key-id-value
```

# DON'T:
```properties
aws.accessKeyId=AKIAIOSFODNN7TEXAMPL
```

## Evidence
b99501ea-0855-4636-a47b-059e3e634395: AWS Access Key ID Value detected. This is a sensitive credential and should not be hardcoded here. Instead, read this va — Severity: HIGH, Type: NEW_THREAT
