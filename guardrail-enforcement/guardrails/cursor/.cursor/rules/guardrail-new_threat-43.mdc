---
description: NEW_THREAT guard — auto-generated from Phoenix finding ab570451-55ad-46dc-900f-dc0436f2527c
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/fileupload/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ab570451-55ad-46dc-900f-dc0436f2527c (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-file-path
```

# DON'T:
```java
                new FileInputStream(
                        unrestrictedFileUpload.getContentDispositionRoot().toFile()
                                + FrameworkConstants.SLASH
                                + fileName);
```

## Evidence
ab570451-55ad-46dc-900f-dc0436f2527c: Detected user input controlling a file path. An attacker could control the location of this file, to include going backw — Severity: HIGH, Type: NEW_THREAT
