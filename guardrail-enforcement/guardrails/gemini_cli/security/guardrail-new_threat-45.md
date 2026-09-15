---
description: NEW_THREAT guard — auto-generated from Phoenix finding c867f67a-f476-488f-ae40-5bed4ce46909
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c867f67a-f476-488f-ae40-5bed4ce46909 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where id='" + sanitized + "'",
```

## Evidence
c867f67a-f476-488f-ae40-5bed4ce46909: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT
