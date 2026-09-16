---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2e5478b5-5678-4d27-bf00-61901fdf7553
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2e5478b5-5678-4d27-bf00-61901fdf7553 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
        return new ResponseEntity<>(payload.toString(), HttpStatus.OK);
```

## Evidence
2e5478b5-5678-4d27-bf00-61901fdf7553: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT
