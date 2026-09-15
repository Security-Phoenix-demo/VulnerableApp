---
description: NEW_THREAT guard — auto-generated from Phoenix finding 9ba529ef-4f05-4248-b751-20149133f933
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 9ba529ef-4f05-4248-b751-20149133f933 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                "select * from cars where id=" + id, this::resultSetToResponse);
```

## Evidence
9ba529ef-4f05-4248-b751-20149133f933: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT
