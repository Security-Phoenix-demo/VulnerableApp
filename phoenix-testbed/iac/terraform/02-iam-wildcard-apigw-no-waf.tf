# INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT deployable infrastructure.
# All credentials are FAKE/SYNTHETIC (alphabet sequences / AWS documentation examples).
#
# TARGETS TWO RULES from one asset set:
#   PHX-IAC-COMB-003 "IAM Action:* + Resource:* on same role"
#       = rulePattern PHX-IAC-SINK-IAM-WILDCARD + resourceType aws_iam_policy
#   PHX-IAC-COMB-006 "Lambda Action:* + public API Gateway + no WAF"
#       = rulePattern PHX-IAC-SINK-IAM-WILDCARD + resourceType aws_api_gateway_rest_api
#         + absentResourceType aws_wafv2_web_acl
#
# THE WILDCARD MUST BE COMPACT JSON. hasWildcardPolicy() does a literal substring test for
# `"Action":"*"` / `"Resource":"*"` over the joined property text. A pretty-printed or
# heredoc-with-spaces policy (`"Action": "*"`) does NOT match — the space defeats it. That is why
# the policy below is a single escaped compact-JSON string rather than the more readable
# jsonencode()/heredoc form a real module would use.
#
# DO NOT ADD an `aws_wafv2_web_acl` resource anywhere in this repository — it satisfies COMB-006's
# absence component and switches that half off (COMB-003 would still fire).

resource "aws_iam_policy" "phx_testbed_admin_all" {
  name        = "phx-testbed-admin-all"
  description = "Phoenix correlation test fixture — full wildcard, never deploy"

  # Compact JSON on purpose — see the header note on hasWildcardPolicy().
  policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"

  tags = {
    # FAKE — alphabet sequence, no real entropy. Taint origin (path matches /api[_-]?key/).
    deploy_api_key = "abcdef1234567890ABCDEF1234567890"
  }
}

resource "aws_iam_role" "phx_testbed_lambda_role" {
  name               = "phx-testbed-lambda-role"
  assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
}

resource "aws_iam_role_policy_attachment" "phx_testbed_lambda_admin" {
  role       = aws_iam_role.phx_testbed_lambda_role.name
  policy_arn = aws_iam_policy.phx_testbed_admin_all.arn
}

# Public API Gateway with no authorizer and no WAF — COMB-006's second component.
resource "aws_api_gateway_rest_api" "phx_testbed_public_api" {
  name        = "phx-testbed-public-api"
  description = "Phoenix correlation test fixture — no authorizer, no WAF"
}

resource "aws_api_gateway_method" "phx_testbed_any" {
  rest_api_id   = aws_api_gateway_rest_api.phx_testbed_public_api.id
  resource_id   = aws_api_gateway_rest_api.phx_testbed_public_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}
