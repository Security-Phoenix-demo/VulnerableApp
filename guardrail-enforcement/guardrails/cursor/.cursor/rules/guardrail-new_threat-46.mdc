---
description: NEW_THREAT guard — auto-generated from Phoenix finding dd078f20-df4d-41a0-a6a3-2dfa10277675
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding dd078f20-df4d-41a0-a6a3-2dfa10277675 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where " + whereClause,
```

## Evidence
dd078f20-df4d-41a0-a6a3-2dfa10277675: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT
