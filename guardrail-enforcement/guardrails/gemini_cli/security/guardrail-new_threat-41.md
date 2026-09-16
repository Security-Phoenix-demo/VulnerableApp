---
description: NEW_THREAT guard — auto-generated from Phoenix finding 13c933d1-8bd4-4ad1-a5e3-c748561119fb
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/secretleak/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 13c933d1-8bd4-4ad1-a5e3-c748561119fb (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-aws-access-key-id-value
```

# DON'T:
```java
    private static final String AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7TEXAMPL";
```

## Evidence
13c933d1-8bd4-4ad1-a5e3-c748561119fb: AWS Access Key ID Value detected. This is a sensitive credential and should not be hardcoded here. Instead, read this va — Severity: HIGH, Type: NEW_THREAT
