# locals.tf

# Define common tags to be applied to all resources
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = terraform
  }

  # Map database engine to engine family for RDS Proxy
  engine_family = lookup(
    {
      "mysql"     = "MYSQL"
      "postgres"  = "POSTGRESQL"
      "sqlserver" = "SQLSERVER"
    },
    lower(var.database_engine),
    "MYSQL" # Default to MYSQL if not found
  )

  # Parse the IP addresses into a list (will be populated after Lambda invocation)
  rds_proxy_ips = can(data.aws_ssm_parameter.rds_proxy_ips.value) ? split(",", data.aws_ssm_parameter.rds_proxy_ips.value) : []
}
