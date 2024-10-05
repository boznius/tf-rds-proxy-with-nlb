# rds_proxy.tf

resource "aws_db_proxy" "this" {
  name                     = "my-rds-proxy"
  engine_family            = var.engine
  role_arn                 = var.rds_proxy_iam_auth_role_arn
  vpc_security_group_ids   = [aws_security_group.rds_proxy.id]
  vpc_subnet_ids           = data.aws_subnet_ids.default.ids

  # Authentication configuration
  auth {
    auth_scheme = "SECRETS"
    secret_arn  = var.rds_proxy_secrets[0]
    iam_auth    = "REQUIRED"
  }

  require_tls = true

  tags = local.common_tags
}
