# INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT deployable infrastructure.
# All credentials are FAKE/SYNTHETIC (AWS's own published documentation examples — zero entropy).
#
# TARGET: PHX-IAC-COMB-002 "Public S3 + unencrypted + no logging"  -> escalates HIGH to CRITICAL
#         plus correlation edge C (Secret <-> IaC asset chain)
#
# HOW IT FIRES (mechanism, verified against IacTaintService/IacToxicCombinationEngine):
#   1. `tags.backup_access_key` matches IacTaintService.CREDENTIAL_KEY (/access[_-]?key/) on its
#      PROPERTY PATH, so it becomes a LITERAL_CREDENTIAL taint origin.
#   2. A LITERAL_CREDENTIAL origin seeds the taint BFS at the asset that CONTAINS it (seedsFor) —
#      which is this same bucket. That is deliberate: origin and sink in one asset is the shortest
#      provable path.
#   3. `acl = "public-read"` makes hasPublicAcl() true on an `aws_s3_bucket`, so the BFS terminates
#      on sink rule PHX-IAC-SINK-PUBLIC-S3.
#   4. COMB-002 additionally requires propertyMatch `acl=public-read` (a TOP-LEVEL property key —
#      which is why `acl` is written as a top-level attribute, not inside a nested block) and
#      absentResourceType `aws_s3_bucket_logging`.
#
# DO NOT ADD an `aws_s3_bucket_logging` resource anywhere in this repository — it satisfies
# COMB-002's absence component and silently switches this fixture off.
#
# NO `pragma: allowlist secret` HERE, DELIBERATELY. .claude/rules/test-fixture-secret-hygiene.md
# asks for that pragma so credential-format fixtures do not pollute CI. This fixture's entire
# purpose is the opposite: it MUST be detected, by both the secret scanner and the IaC scanner, or
# it cannot seed a correlation. The rule's synthetic-value requirement is honoured in full (AWS's
# documented example key, no real entropy); only its suppression half is intentionally omitted.
# Do not "fix" this by adding the pragma or splitting the literal.

resource "aws_s3_bucket" "phx_testbed_public_data" {
  bucket = "phx-testbed-public-data"

  # Top-level attribute on purpose — COMB-002's propertyMatch reads properties["acl"].
  acl = "public-read"

  # No server_side_encryption_configuration and no logging block: both absences are the point.

  tags = {
    Name    = "phx-testbed"
    Purpose = "phoenix-correlation-test-fixture"

    # FAKE — AWS's own documentation example key pair. Taint origin for step 1 above.
    backup_access_key = "AKIAIOSFODNN7EXAMPLE"
    backup_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }
}

# Public bucket policy — a second, independent public-exposure signal on the same asset.
resource "aws_s3_bucket_policy" "phx_testbed_public_data_policy" {
  bucket = aws_s3_bucket.phx_testbed_public_data.id
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"PublicReadGetObject\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::phx-testbed-public-data/*\"}]}"
}
