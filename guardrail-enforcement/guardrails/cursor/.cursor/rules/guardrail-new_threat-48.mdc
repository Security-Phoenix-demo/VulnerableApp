---
description: NEW_THREAT guard — auto-generated from Phoenix finding 73a30a59-08f9-4726-a3fb-d718f7d761c9
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 73a30a59-08f9-4726-a3fb-d718f7d761c9 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-file-path
```

# DON'T:
```java
                this.getClass().getClassLoader().getResourceAsStream(BASE_PATH + sanitized)) {
```

## Evidence
73a30a59-08f9-4726-a3fb-d718f7d761c9: Detected user input controlling a file path. An attacker could control the location of this file, to include going backw — Severity: HIGH, Type: NEW_THREAT
