---
description: NEW_THREAT guard — auto-generated from Phoenix finding 174c586a-e4db-41e4-98c2-a5e0785e0a7f
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/ssrf/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 174c586a-e4db-41e4-98c2-a5e0785e0a7f (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-url-host
```

# DON'T:
```java
            URL u = new URL(url);
```

## Evidence
174c586a-e4db-41e4-98c2-a5e0785e0a7f: User data flows into the host portion of this manually-constructed URL. This could allow an attacker to send data to the — Severity: HIGH, Type: NEW_THREAT
