---
description: NEW_THREAT guard — auto-generated from Phoenix finding 235bdb4b-21aa-4ccd-9ef5-80c1b4161abf
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/secretleak/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 235bdb4b-21aa-4ccd-9ef5-80c1b4161abf (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-generic-secret
```

# DON'T:
```java
    private static final String NOT_A_SECRET = "YjM4YTIxNzUtZmYxNy00Y2FhLWIzMWQtNjk1YjNl";
```

## Evidence
235bdb4b-21aa-4ccd-9ef5-80c1b4161abf: Generic Secret detected — Severity: HIGH, Type: NEW_THREAT
