# INTENTIONALLY VULNERABLE — Test fixture for CI/CD exploitation assessment
# Scanner should flag: V3 (Deployment Credential Theft)
# All credentials are FAKE/SYNTHETIC test values

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAZTESTTERRAFORM01"
  secret_key = "wJalrXUtnFEMI/K7MDENG/TERRAFORMFAKETESTKEY1"
}

resource "aws_s3_bucket" "data" {
  bucket = "phoenix-prod-data-bucket"
}

resource "aws_iam_user" "deploy_bot" {
  name = "deploy-bot"
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.deploy_bot.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
