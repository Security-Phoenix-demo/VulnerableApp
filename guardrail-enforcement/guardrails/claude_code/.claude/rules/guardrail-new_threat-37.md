---
description: NEW_THREAT guard — auto-generated from Phoenix finding 11bd78d1-5a80-4035-8cb2-2640e59cbb86
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 11bd78d1-5a80-4035-8cb2-2640e59cbb86 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                                            "select * from cars where id='" + id + "'"),
```

## Evidence
11bd78d1-5a80-4035-8cb2-2640e59cbb86: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT
