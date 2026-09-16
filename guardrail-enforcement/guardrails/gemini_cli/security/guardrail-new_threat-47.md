---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2b9d3fa0-0e87-4c8b-8d31-3b4fdc8e4039
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2b9d3fa0-0e87-4c8b-8d31-3b4fdc8e4039 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-file-path
```

# DON'T:
```java
                this.getClass().getClassLoader().getResourceAsStream(metadata.getFullPath())) {
```

## Evidence
2b9d3fa0-0e87-4c8b-8d31-3b4fdc8e4039: Detected user input controlling a file path. An attacker could control the location of this file, to include going backw — Severity: HIGH, Type: NEW_THREAT
