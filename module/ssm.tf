# ssm.tf

# Fetch the IP addresses stored by the Lambda function
data "aws_ssm_parameter" "rds_proxy_ips" {
  name           = "/rds_proxy/ip_addresses"
  with_decryption = false
  depends_on     = [aws_lambda_function.resolve_rds_proxy_ips]
}

# Split the IP addresses into a list
locals {
  rds_proxy_ip_addresses = split(",", data.aws_ssm_parameter.rds_proxy_ips.value)
}
