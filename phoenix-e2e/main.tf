# Synthetic IaC scanner fixture. Never apply this configuration.
resource "aws_security_group" "phoenix_pr_e2e" {
  name = "phoenix-pr-e2e-do-not-apply"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
