# data.tf

# Retrieve the IP addresses stored in SSM Parameter Store
data "aws_ssm_parameter" "rds_proxy_ips" {
  name = var.ssm_parameter_name

  # Ensure that the SSM parameter is retrieved after the Lambda function is invoked
  depends_on = [null_resource.invoke_lambda]
}
