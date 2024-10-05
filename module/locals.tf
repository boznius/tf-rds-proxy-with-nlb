# locals.tf

# Define common tags for all resources
locals {
  common_tags = merge(
    {
      "Environment" = "PoC"
      "Terraform"   = "true"
    },
    var.common_tags
  )

  # Determine the RDS Proxy port based on the engine
  rds_proxy_port = var.engine == "postgresql" ? 5432 : 3306
}
