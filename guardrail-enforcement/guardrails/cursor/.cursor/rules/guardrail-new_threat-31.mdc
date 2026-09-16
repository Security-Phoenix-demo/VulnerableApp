---
description: NEW_THREAT guard — auto-generated from Phoenix finding 6c633e5a-f8e5-4762-ba79-102b83e7a66d
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/ssrf/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 6c633e5a-f8e5-4762-ba79-102b83e7a66d (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-url-host
```

# DON'T:
```java
            if (MetaDataServiceMock.isPresent(new URL(url))) {
```

## Evidence
6c633e5a-f8e5-4762-ba79-102b83e7a66d: User data flows into the host portion of this manually-constructed URL. This could allow an attacker to send data to the — Severity: HIGH, Type: NEW_THREAT
