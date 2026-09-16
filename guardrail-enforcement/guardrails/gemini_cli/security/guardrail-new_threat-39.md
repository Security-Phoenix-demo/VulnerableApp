---
description: NEW_THREAT guard — auto-generated from Phoenix finding 9d5584de-8d36-4373-8bec-e10103766d74
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 9d5584de-8d36-4373-8bec-e10103766d74 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where id=" + id,
```

## Evidence
9d5584de-8d36-4373-8bec-e10103766d74: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT
