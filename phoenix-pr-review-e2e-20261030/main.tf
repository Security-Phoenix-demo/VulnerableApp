# TEST ONLY. Do not run terraform apply on these deliberately unsafe resources.

resource "aws_security_group" "phoenix_pr_review_open_ssh" {
  name = "phoenix-pr-review-e2e-open-ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "phoenix_pr_review_public" {
  bucket = "phoenix-pr-review-e2e-never-create"
  acl    = "public-read"
}
