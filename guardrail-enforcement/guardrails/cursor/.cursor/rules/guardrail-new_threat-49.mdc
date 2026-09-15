---
description: NEW_THREAT guard — auto-generated from Phoenix finding 65a62435-27d1-4967-a02f-8aabd63d3d60
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 65a62435-27d1-4967-a02f-8aabd63d3d60 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-file-path
```

# DON'T:
```java
                this.getClass().getClassLoader().getResourceAsStream(BASE_PATH + fileName)) {
```

## Evidence
65a62435-27d1-4967-a02f-8aabd63d3d60: Detected user input controlling a file path. An attacker could control the location of this file, to include going backw — Severity: HIGH, Type: NEW_THREAT
