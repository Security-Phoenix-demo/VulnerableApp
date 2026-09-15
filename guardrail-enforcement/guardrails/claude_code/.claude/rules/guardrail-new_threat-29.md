---
description: NEW_THREAT guard — auto-generated from Phoenix finding 153a4935-7418-4d2b-978b-302bc467545d
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 153a4935-7418-4d2b-978b-302bc467545d (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
            return new ResponseEntity<>(payload, HttpStatus.OK);
```

## Evidence
153a4935-7418-4d2b-978b-302bc467545d: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT
