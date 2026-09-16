---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5f66617f-904f-47e2-8a5d-902d5bd1d7d5
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5f66617f-904f-47e2-8a5d-902d5bd1d7d5 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
        return new ResponseEntity<String>(payload.toString(), HttpStatus.OK);
```

## Evidence
5f66617f-904f-47e2-8a5d-902d5bd1d7d5: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT
