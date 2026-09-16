# Guardrails

Generated Phoenix guardrails for Codex CLI.

## Rule 1: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 82101e6a-c7ce-41fe-8717-0ec876b33445
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 82101e6a-c7ce-41fe-8717-0ec876b33445 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("helpText").innerHTML = helpText;
```

## Evidence
82101e6a-c7ce-41fe-8717-0ec876b33445: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 2: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding ea25b1b5-e768-440f-8d50-c17b61ee1863
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ea25b1b5-e768-440f-8d50-c17b61ee1863 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  detailTitle.innerHTML = vulnerableAppEndPointData[id]["Description"];
```

## Evidence
ea25b1b5-e768-440f-8d50-c17b61ee1863: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 3: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 02e7c7d7-79fa-4d38-a3b4-de58f1b10b10
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 02e7c7d7-79fa-4d38-a3b4-de58f1b10b10 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-document-method
```

# DON'T:
```javascript
  span.innerHTML = isSecure ? variantTooltip.secure : variantTooltip.unsecure;
```

## Evidence
02e7c7d7-79fa-4d38-a3b4-de58f1b10b10: User controlled data in methods like 'innerHTML', 'outerHTML' or 'document.write' is an anti-pattern that can lead to XS — Severity: HIGH, Type: NEW_THREAT


## Rule 4: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding ddba1184-bd22-4c7b-b7f0-5ef5596002e1
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ddba1184-bd22-4c7b-b7f0-5ef5596002e1 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
      detailTitle.innerHTML = responseText;
```

## Evidence
ddba1184-bd22-4c7b-b7f0-5ef5596002e1: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 5: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 498f139f-b27c-4dcd-a3aa-2426e4908881
alwaysApply: false
globs: ["src/main/resources/static/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 498f139f-b27c-4dcd-a3aa-2426e4908881 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("vulnerabilityDescription").innerHTML =
      vulnerableAppEndPointData[id]["Description"];
```

## Evidence
498f139f-b27c-4dcd-a3aa-2426e4908881: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 6: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding a3cc3166-e29c-4bea-995b-c43c316b4892
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a3cc3166-e29c-4bea-995b-c43c316b4892 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("bookInformation").innerHTML = data;
```

## Evidence
a3cc3166-e29c-4bea-995b-c43c316b4892: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 7: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 4b28020f-315c-4edb-b963-7255b9de8eeb
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 4b28020f-315c-4edb-b963-7255b9de8eeb (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  otherElement.innerHTML = otherComments;
```

## Evidence
4b28020f-315c-4edb-b963-7255b9de8eeb: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 8: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding a501b04d-ecef-4019-91c5-42ec2b944a37
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a501b04d-ecef-4019-91c5-42ec2b944a37 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  publisherElement.innerHTML = publisher;
```

## Evidence
a501b04d-ecef-4019-91c5-42ec2b944a37: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 9: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  isbnElement.innerHTML = isbn;
```

## Evidence
ec745aa0-e9aa-4edc-a9d2-b4124a9e6a3e: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 10: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding d5f511f6-11de-4135-9aaf-e1d30328775a
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding d5f511f6-11de-4135-9aaf-e1d30328775a (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  authorElement.innerHTML = author;
```

## Evidence
d5f511f6-11de-4135-9aaf-e1d30328775a: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 11: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2
alwaysApply: false
globs: ["src/main/resources/static/templates/XXEVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  bookNameElement.innerHTML = bookName;
```

## Evidence
5372d1d9-5297-47f7-b2f2-77f0eb6d7fb2: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 12: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 7d9e4726-35c1-4c78-8c10-fda499edae8f
alwaysApply: false
globs: ["src/main/resources/static/templates/XSSWithNullBytesImgTagAttribute/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 7d9e4726-35c1-4c78-8c10-fda499edae8f (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("image").innerHTML = data;
```

## Evidence
7d9e4726-35c1-4c78-8c10-fda499edae8f: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 13: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding a50babcb-65c7-44e3-a2da-802817a99b6b
alwaysApply: false
globs: ["src/main/resources/static/templates/XSSWithHtmlTagInjection/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding a50babcb-65c7-44e3-a2da-802817a99b6b (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-document-method
```

# DON'T:
```javascript
  parentContainer.innerHTML = data;
```

## Evidence
a50babcb-65c7-44e3-a2da-802817a99b6b: User controlled data in methods like 'innerHTML', 'outerHTML' or 'document.write' is an anti-pattern that can lead to XS — Severity: HIGH, Type: NEW_THREAT


## Rule 14: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 61508655-3a7e-4220-a5e0-0c57834bb18e
alwaysApply: false
globs: ["src/main/resources/static/templates/UnrestrictedFileUpload/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 61508655-3a7e-4220-a5e0-0c57834bb18e (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("uploaded_file_info").innerHTML = data.isValid
    ? "File uploaded at location:" + data.content
    : data.content;
```

## Evidence
61508655-3a7e-4220-a5e0-0c57834bb18e: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 15: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding f490fdd9-b7d9-4415-970b-bae74e1961b2
alwaysApply: false
globs: ["src/main/resources/static/templates/UnionBasedSQLInjectionVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding f490fdd9-b7d9-4415-970b-bae74e1961b2 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("carInformation").innerHTML =
    "<img src='" + data.imagePath + "' width='900'/>";
```

## Evidence
f490fdd9-b7d9-4415-970b-bae74e1961b2: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 16: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5ff5c55a-1c87-4bfc-b8db-37a6c90fc306
alwaysApply: false
globs: ["src/main/resources/static/templates/SSRFVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5ff5c55a-1c87-4bfc-b8db-37a6c90fc306 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("projectsResponse").innerHTML = tableInformation;
```

## Evidence
5ff5c55a-1c87-4bfc-b8db-37a6c90fc306: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 17: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 8c9a5110-003a-419d-a7af-699660885e6c
alwaysApply: false
globs: ["src/main/resources/static/templates/PersistentXSSInHTMLTagVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 8c9a5110-003a-419d-a7af-699660885e6c (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("allPosts").innerHTML = data;
```

## Evidence
8c9a5110-003a-419d-a7af-699660885e6c: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 18: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389
alwaysApply: false
globs: ["src/main/resources/static/templates/PersistentXSSInHTMLTagVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  postDiv.innerHTML = post.content;
```

## Evidence
5ef3e540-2c14-4bc3-9ba3-63b9e1b7d389: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 19: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding e65ac753-bcb0-4083-b7c2-9aaeecb0b66f
alwaysApply: false
globs: ["src/main/resources/static/templates/PathTraversal/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding e65ac753-bcb0-4083-b7c2-9aaeecb0b66f (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("Information").innerHTML = tableInformation;
```

## Evidence
e65ac753-bcb0-4083-b7c2-9aaeecb0b66f: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 20: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding b12a33f3-2056-4fd8-8563-2509a4b93659
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/keys/**/*.pem"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding b12a33f3-2056-4fd8-8563-2509a4b93659 (2026-08-02)

# DO:
```pem
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-private-key
```

# DON'T:
```pem
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDG86CoStCZbgTi
```

## Evidence
b12a33f3-2056-4fd8-8563-2509a4b93659: Private Key detected. This is a sensitive credential and should not be hardcoded here. Instead, store this in a separate — Severity: HIGH, Type: NEW_THREAT


## Rule 21: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5350d0a8-9561-492b-b923-cfa5a51f88b7
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/LEVEL_7/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5350d0a8-9561-492b-b923-cfa5a51f88b7 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("jwt").innerHTML = data.content;
```

## Evidence
5350d0a8-9561-492b-b923-cfa5a51f88b7: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 22: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2a0fa72e-5a9c-4b03-8428-456a83626ecb
alwaysApply: false
globs: ["src/main/resources/static/templates/JWTVulnerability/LEVEL_7/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2a0fa72e-5a9c-4b03-8428-456a83626ecb (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("verificationResponse").innerHTML =
      "JWT: " + data.content + " is not valid. Please try again";
```

## Evidence
2a0fa72e-5a9c-4b03-8428-456a83626ecb: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 23: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding c017f742-4eab-4a4a-9710-832e5ebac1ce
alwaysApply: false
globs: ["src/main/resources/static/templates/ErrorBasedSQLInjectionVulnerability/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c017f742-4eab-4a4a-9710-832e5ebac1ce (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
    document.getElementById("carInformation").innerHTML =
      "<img src='" + data.carInformation.imagePath + "' width='900'/>";
```

## Evidence
c017f742-4eab-4a4a-9710-832e5ebac1ce: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 24: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding f5438e61-f414-4138-a1e8-1198f5a88577
alwaysApply: false
globs: ["src/main/resources/static/templates/CommandInjection/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding f5438e61-f414-4138-a1e8-1198f5a88577 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("pingUtilityResponse").innerHTML = data.content;
```

## Evidence
f5438e61-f414-4138-a1e8-1198f5a88577: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 25: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 260747c4-06df-4a8b-9d1e-51d16e5ffcc8
alwaysApply: false
globs: ["src/main/resources/sampleVulnerability/staticResources/LEVEL_1/**/*.js"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 260747c4-06df-4a8b-9d1e-51d16e5ffcc8 (2026-08-02)

# DO:
```javascript
Apply secure coding best practices for rules.semgrep-rules.javascript.browser.security.insecure-innerhtml
```

# DON'T:
```javascript
  document.getElementById("response").innerHTML = data.content;
```

## Evidence
260747c4-06df-4a8b-9d1e-51d16e5ffcc8: User controlled data in a '$EL.innerHTML' is an anti-pattern that can lead to XSS vulnerabilities — Severity: HIGH, Type: NEW_THREAT


## Rule 26: NEW_THREAT

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


## Rule 27: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding b99501ea-0855-4636-a47b-059e3e634395
alwaysApply: false
globs: ["src/main/resources/**/*.properties"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding b99501ea-0855-4636-a47b-059e3e634395 (2026-08-02)

# DO:
```properties
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-aws-access-key-id-value
```

# DON'T:
```properties
aws.accessKeyId=AKIAIOSFODNN7TEXAMPL
```

## Evidence
b99501ea-0855-4636-a47b-059e3e634395: AWS Access Key ID Value detected. This is a sensitive credential and should not be hardcoded here. Instead, read this va — Severity: HIGH, Type: NEW_THREAT


## Rule 28: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 5f66617f-904f-47e2-8a5d-902d5bd1d7d5
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 5f66617f-904f-47e2-8a5d-902d5bd1d7d5 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
        return new ResponseEntity<String>(payload.toString(), HttpStatus.OK);
```

## Evidence
5f66617f-904f-47e2-8a5d-902d5bd1d7d5: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT


## Rule 29: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 153a4935-7418-4d2b-978b-302bc467545d
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 153a4935-7418-4d2b-978b-302bc467545d (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
            return new ResponseEntity<>(payload, HttpStatus.OK);
```

## Evidence
153a4935-7418-4d2b-978b-302bc467545d: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT


## Rule 30: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2e5478b5-5678-4d27-bf00-61901fdf7553
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2e5478b5-5678-4d27-bf00-61901fdf7553 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
        return new ResponseEntity<>(payload.toString(), HttpStatus.OK);
```

## Evidence
2e5478b5-5678-4d27-bf00-61901fdf7553: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT


## Rule 31: NEW_THREAT

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


## Rule 32: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 93ebc18f-bf12-433b-b141-e0914c8da5cb
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/xss/reflected/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 93ebc18f-bf12-433b-b141-e0914c8da5cb (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-html-string
```

# DON'T:
```java
                String.format(vulnerablePayloadWithPlaceHolder, imageLocation), HttpStatus.OK);
```

## Evidence
93ebc18f-bf12-433b-b141-e0914c8da5cb: Detected user input flowing into a manually constructed HTML string. You may be accidentally bypassing secure methods of — Severity: HIGH, Type: NEW_THREAT


## Rule 33: NEW_THREAT

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


## Rule 34: NEW_THREAT

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


## Rule 35: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 63db7bc5-7fb9-429c-8b8f-9226af43cad5
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 63db7bc5-7fb9-429c-8b8f-9226af43cad5 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                "select * from cars where id='" + id + "'", this::resultSetToResponse);
```

## Evidence
63db7bc5-7fb9-429c-8b8f-9226af43cad5: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 36: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 9ba529ef-4f05-4248-b751-20149133f933
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 9ba529ef-4f05-4248-b751-20149133f933 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                "select * from cars where id=" + id, this::resultSetToResponse);
```

## Evidence
9ba529ef-4f05-4248-b751-20149133f933: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 37: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 11bd78d1-5a80-4035-8cb2-2640e59cbb86
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 11bd78d1-5a80-4035-8cb2-2640e59cbb86 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                                            "select * from cars where id='" + id + "'"),
```

## Evidence
11bd78d1-5a80-4035-8cb2-2640e59cbb86: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 38: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 93319c79-18ad-4b40-9502-dacd0fcc0692
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 93319c79-18ad-4b40-9502-dacd0fcc0692 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where id='" + id + "'",
```

## Evidence
93319c79-18ad-4b40-9502-dacd0fcc0692: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 39: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 9d5584de-8d36-4373-8bec-e10103766d74
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/sqlInjection/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 9d5584de-8d36-4373-8bec-e10103766d74 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where id=" + id,
```

## Evidence
9d5584de-8d36-4373-8bec-e10103766d74: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 40: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 235bdb4b-21aa-4ccd-9ef5-80c1b4161abf
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/secretleak/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 235bdb4b-21aa-4ccd-9ef5-80c1b4161abf (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-generic-secret
```

# DON'T:
```java
    private static final String NOT_A_SECRET = "YjM4YTIxNzUtZmYxNy00Y2FhLWIzMWQtNjk1YjNl";
```

## Evidence
235bdb4b-21aa-4ccd-9ef5-80c1b4161abf: Generic Secret detected — Severity: HIGH, Type: NEW_THREAT


## Rule 41: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 13c933d1-8bd4-4ad1-a5e3-c748561119fb
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/secretleak/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 13c933d1-8bd4-4ad1-a5e3-c748561119fb (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.generic.secrets.security.detected-aws-access-key-id-value
```

# DON'T:
```java
    private static final String AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7TEXAMPL";
```

## Evidence
13c933d1-8bd4-4ad1-a5e3-c748561119fb: AWS Access Key ID Value detected. This is a sensitive credential and should not be hardcoded here. Instead, read this va — Severity: HIGH, Type: NEW_THREAT


## Rule 42: NEW_THREAT

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


## Rule 43: NEW_THREAT

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


## Rule 44: NEW_THREAT

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


## Rule 45: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding c867f67a-f476-488f-ae40-5bed4ce46909
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding c867f67a-f476-488f-ae40-5bed4ce46909 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where id='" + sanitized + "'",
```

## Evidence
c867f67a-f476-488f-ae40-5bed4ce46909: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 46: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding dd078f20-df4d-41a0-a6a3-2dfa10277675
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding dd078f20-df4d-41a0-a6a3-2dfa10277675 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-sql-string
```

# DON'T:
```java
                            "select * from cars where " + whereClause,
```

## Evidence
dd078f20-df4d-41a0-a6a3-2dfa10277675: User data flows into this manually-constructed SQL string. User data can be safely inserted into SQL strings using prepa — Severity: HIGH, Type: NEW_THREAT


## Rule 47: NEW_THREAT

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


## Rule 48: NEW_THREAT

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


## Rule 49: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 65a62435-27d1-4967-a02f-8aabd63d3d60
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 65a62435-27d1-4967-a02f-8aabd63d3d60 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.spring.security.injection.tainted-file-path
```

# DON'T:
```java
                this.getClass().getClassLoader().getResourceAsStream(BASE_PATH + fileName)) {
```

## Evidence
65a62435-27d1-4967-a02f-8aabd63d3d60: Detected user input controlling a file path. An attacker could control the location of this file, to include going backw — Severity: HIGH, Type: NEW_THREAT


## Rule 50: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 339693a6-0495-433a-bba2-36fd29b094de
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 339693a6-0495-433a-bba2-36fd29b094de (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.lang.security.audit.command-injection-process-builder
```

# DON'T:
```java
            process = new /* REDACTED */(new String[] {"cmd", "/c", command})
```

## Evidence
339693a6-0495-433a-bba2-36fd29b094de: A formatted or concatenated string was detected as input to a /* REDACTED */ call. This is dangerous if a variable is co — Severity: HIGH, Type: NEW_THREAT


## Rule 51: NEW_THREAT

---
description: NEW_THREAT guard — auto-generated from Phoenix finding 2a96977e-dfa5-4de0-8614-8af8e4b5a265
alwaysApply: false
globs: ["src/main/java/org/sasanlabs/service/vulnerability/crossrepo/**/*.java"]
---

**Portability**: ADAPT
**OWASP**: See finding details
**Source**: Phoenix SAST finding 2a96977e-dfa5-4de0-8614-8af8e4b5a265 (2026-08-02)

# DO:
```java
Apply secure coding best practices for rules.semgrep-rules.java.lang.security.audit.command-injection-process-builder
```

# DON'T:
```java
                    new /* REDACTED */(new String[] {"cmd", "/c", "ping -n 2 " + ipAddress})
```

## Evidence
2a96977e-dfa5-4de0-8614-8af8e4b5a265: A formatted or concatenated string was detected as input to a /* REDACTED */ call. This is dangerous if a variable is co — Severity: HIGH, Type: NEW_THREAT


## Rule 52: NEW_THREAT

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


