# Synthetic IaC fixture for PR review. Never run terraform apply on this file.
resource "aws_security_group" "phoenix_pr_review_open_ssh" {
  name = "phoenix-pr-review-open-ssh-fixture"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
