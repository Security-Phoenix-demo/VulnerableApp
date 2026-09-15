---
description: NEW_THREAT guard — auto-generated from Phoenix finding c60fdf5f-d9e2-41c3-9e16-68ddac3fa01c
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/rfi/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c60fdf5f-d9e2-41c3-9e16-68ddac3fa01c (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-url-host
```

# DON'T:
```java
                URL url = new URL(queryParameterURL);
```

## Evidence
c60fdf5f-d9e2-41c3-9e16-68ddac3fa01c: User data flows into the host portion of this manually-constructed URL. This could allow an attacker to send data to the — Severity: HIGH, Type: NEW_THREAT
