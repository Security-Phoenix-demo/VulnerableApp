---
description: NEW_THREAT guard — auto-generated from Phoenix finding 49fb1eb0-1897-4a78-b588-b5f63c8ecae7
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/commandInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 49fb1eb0-1897-4a78-b588-b5f63c8ecae7 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-username-and-password-in-uri
```

# DON'T:
```java
    // http://localhost:9090/vulnerable/CommandInjectionVulnerability/LEVEL_3?ipaddress=192.168.0.1%20%7c%20cat%20/etc/passwd
    @AttackVector(
```

## Evidence
49fb1eb0-1897-4a78-b588-b5f63c8ecae7: Username and password in URI detected — Severity: HIGH, Type: NEW_THREAT
