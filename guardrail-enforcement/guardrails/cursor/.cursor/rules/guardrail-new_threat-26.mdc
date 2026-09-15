---
description: NEW_THREAT guard — auto-generated from Phoenix finding c1c0b4c9-09f3-4a5c-a454-1793e58aee86
alwaysApply: false
globs: ["src/main/resources/attackvectors/**/*.properties"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c1c0b4c9-09f3-4a5c-a454-1793e58aee86 (2026-08-02)

# DO:
```properties
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-jwt-token
```

# DON'T:
```properties
NONE_ALGORITHM_ATTACK_CURL_PAYLOAD=curl 'http://localhost:9090/vulnerable/JWTVulnerability/LEVEL_6' -H 'Cookie: JWTToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.'
```

## Evidence
c1c0b4c9-09f3-4a5c-a454-1793e58aee86: JWT token detected — Severity: HIGH, Type: NEW_THREAT
