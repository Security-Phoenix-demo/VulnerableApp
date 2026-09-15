---
description: NEW_THREAT guard — auto-generated from Phoenix finding bb418ad3-77f7-4d5f-a05f-3dc9965c53c0
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/ssrf/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding bb418ad3-77f7-4d5f-a05f-3dc9965c53c0 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-url-host
```

# DON'T:
```java
            if (new URL(url).getHost().equals("169.254.169.254")) {
```

## Evidence
bb418ad3-77f7-4d5f-a05f-3dc9965c53c0: User data flows into the host portion of this manually-constructed URL. This could allow an attacker to send data to the — Severity: HIGH, Type: NEW_THREAT
