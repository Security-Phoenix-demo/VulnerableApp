---
description: NEW_THREAT guard — auto-generated from Phoenix finding 339693a6-0495-433a-bba2-36fd29b094de
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 339693a6-0495-433a-bba2-36fd29b094de (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.lang.security.audit.command-injection-process-builder
```

# DON'T:
```java
            process = new /* REDACTED */(new String[] {"cmd", "/c", command})
```

## Evidence
339693a6-0495-433a-bba2-36fd29b094de: A formatted or concatenated string was detected as input to a /* REDACTED */ call. This is dangerous if a variable is co — Severity: HIGH, Type: NEW_THREAT
