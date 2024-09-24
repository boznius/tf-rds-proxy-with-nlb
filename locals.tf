# locals.tf

# Define common tags to be applied to all resources
locals {
  common_tags = {
    Project     = PoC
    Environment = Dev
    Owner       = terraform
  }

  # Parse the IP addresses into a list (will be populated after Lambda invocation)
  rds_proxy_ips = can(data.aws_ssm_parameter.rds_proxy_ips.value) ? split(",", data.aws_ssm_parameter.rds_proxy_ips.value) : []
}
