# INTENTIONALLY VULNERABLE — Phoenix correlation test fixture. NOT deployable infrastructure.
# All credentials are FAKE/SYNTHETIC (alphabet sequence, no real entropy).
#
# TARGET: PHX-IAC-COMB-007 "RDS publicly accessible + weak SG + no encryption"
#   = propertyMatch `publicly_accessible=true` + rulePattern PHX-IAC-SINK-OPEN-SG
#
# HOW IT FIRES:
#   1. `password` on the db instance matches CREDENTIAL_KEY -> LITERAL_CREDENTIAL taint origin,
#      seeded at aws_db_instance.phx_testbed_public_db.
#   2. `vpc_security_group_ids` references the security group, which is what puts the SG in the
#      taint BFS's adjacency from that seed. WITHOUT that reference the SG is an island and the
#      PHX-IAC-SINK-OPEN-SG sink is never reached — the reference is load-bearing, not decoration.
#   3. `cidr_blocks = ["0.0.0.0/0"]` makes hasOpenIngress() true on an aws_security_group.
#   4. `publicly_accessible = true` is a TOP-LEVEL attribute because COMB-007's propertyMatch reads
#      properties["publicly_accessible"]. A boolean JsonNode's asText() is "true", which satisfies
#      the contains("true") test.
#
# `storage_encrypted` is deliberately absent (defaults false) — the rule's third named component.

resource "aws_security_group" "phx_testbed_open_db_sg" {
  name        = "phx-testbed-open-db-sg"
  description = "Phoenix correlation test fixture — world-open ingress, never deploy"

  ingress {
    description = "Postgres open to the internet"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH open to the internet (IPv6)"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "phx_testbed_public_db" {
  identifier     = "phx-testbed-public-db"
  engine         = "postgres"
  instance_class = "db.t3.micro"
  username       = "phxtestbed"

  # FAKE — alphabet sequence. Taint origin (path matches /password/).
  password = "aBcDeFgHiJkLmNoPqRsTuVwXyZ012345"

  # Top-level attribute on purpose — COMB-007's propertyMatch reads properties["publicly_accessible"].
  publicly_accessible = true

  # No storage_encrypted, no backup_retention_period, no deletion protection.
  skip_final_snapshot = true

  # Load-bearing: this reference is what makes the open SG reachable in the taint BFS (step 2).
  vpc_security_group_ids = [aws_security_group.phx_testbed_open_db_sg.id]
}
