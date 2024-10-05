# security_groups.tf

# Security Group for RDS Proxy
resource "aws_security_group" "rds_proxy" {
  name   = "rds-proxy-sg"
  vpc_id = data.aws_vpc.default.id

  # Ingress rule to allow traffic from NLB
  ingress {
    from_port       = local.rds_proxy_port
    to_port         = local.rds_proxy_port
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  # Adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Security Group for NLB (if needed)
resource "aws_security_group" "nlb" {
  name   = "nlb-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = local.rds_proxy_port
    to_port         = local.rds_proxy_port
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  # Adjust as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
