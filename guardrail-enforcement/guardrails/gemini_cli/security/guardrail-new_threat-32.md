---
description: NEW_THREAT guard — auto-generated from Phoenix finding 93ebc18f-bf12-433b-b141-e0914c8da5cb
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 93ebc18f-bf12-433b-b141-e0914c8da5cb (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
                String.format(vulnerablePayloadWithPlaceHolder, imageLocation), HttpStatus.OK);
```

## Evidence
93ebc18f-bf12-433b-b141-e0914c8da5cb: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT
