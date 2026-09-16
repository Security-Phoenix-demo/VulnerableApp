---
description: NEW_THREAT guard — auto-generated from Phoenix finding db29b36a-9844-4710-bbc9-599fea3648fc
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding db29b36a-9844-4710-bbc9-599fea3648fc (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-url-host
```

# DON'T:
```java
            URLConnection connection = new URL(fileUrl).openConnection();
```

## Evidence
db29b36a-9844-4710-bbc9-599fea3648fc: User data flows into the host portion of this manually-constructed URL. This could allow an attacker to send data to the — Severity: HIGH, Type: NEW_THREAT
