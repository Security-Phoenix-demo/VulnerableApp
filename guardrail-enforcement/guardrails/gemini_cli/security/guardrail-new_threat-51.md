---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2a96977e-dfa5-4de0-8614-8af8e4b5a265
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2a96977e-dfa5-4de0-8614-8af8e4b5a265 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.lang.security.audit.command-injection-process-builder
```

# DON'T:
```java
                    new /* REDACTED */(new String[] {"cmd", "/c", "ping -n 2 " + ipAddress})
```

## Evidence
2a96977e-dfa5-4de0-8614-8af8e4b5a265: A formatted or concatenated string was detected as input to a /* REDACTED */ call. This is dangerous if a variable is co — Severity: HIGH, Type: NEW_THREAT
