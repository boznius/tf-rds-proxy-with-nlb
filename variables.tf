# variables.tf

# Define the environment (e.g., dev, prod)
variable "environment" {
  description = "The environment for tagging and naming."
  type        = string
}

# Define the project name
variable "project_name" {
  description = "The project name for tagging and naming."
  type        = string
}

# VPC ID where resources will be deployed
variable "vpc_id" {
  description = "The VPC ID where resources will be deployed."
  type        = string
}

# Subnet IDs for deploying RDS Proxy and NLB
variable "subnet_ids" {
  description = "List of subnet IDs for the RDS Proxy and NLB."
  type        = list(string)
}

# Subnet IDs for RDS Proxy (can be the same as NLB or different)
variable "rds_proxy_subnet_ids" {
  description = "List of subnet IDs for the RDS Proxy."
  type        = list(string)
}

# Security group IDs for the RDS Proxy
variable "rds_proxy_security_group_ids" {
  description = "List of security group IDs for the RDS Proxy."
  type        = list(string)
}

# Security group IDs for the NLB
variable "nlb_security_group_ids" {
  description = "List of security group IDs for the NLB."
  type        = list(string)
}

# The endpoint of the RDS Proxy (optional if creating within this module)
variable "rds_proxy_endpoint" {
  description = "The endpoint of the RDS Proxy."
  type        = string
  default     = null
}

# RDS Proxy name
variable "rds_proxy_name" {
  description = "Name of the RDS Proxy."
  type        = string
}

# RDS Proxy target RDS instance or cluster ARN
variable "rds_proxy_target_arn" {
  description = "ARN of the RDS DB instance or cluster to target."
  type        = string
}

# IAM role ARN for the RDS Proxy to access secrets
variable "rds_proxy_iam_auth_role_arn" {
  description = "IAM role ARN that the RDS Proxy uses to access secrets in AWS Secrets Manager."
  type        = string
}

# Secrets Manager secret IDs for the RDS Proxy
variable "rds_proxy_secrets" {
  description = "List of Secrets Manager secret IDs for the RDS Proxy."
  type        = list(string)
}

# S3 bucket containing the Lambda function code
variable "lambda_function_s3_bucket" {
  description = "S3 bucket containing the Lambda function code."
  type        = string
}

# S3 key for the Lambda function code
variable "lambda_function_s3_key" {
  description = "S3 key for the Lambda function code."
  type        = string
}

# Handler for the Lambda function
variable "lambda_function_handler" {
  description = "Handler for the Lambda function."
  type        = string
  default     = "index.handler"
}

# Runtime for the Lambda function
variable "lambda_function_runtime" {
  description = "Runtime for the Lambda function."
  type        = string
  default     = "python3.9"
}

# The name of the SSM parameter to store IP addresses
variable "ssm_parameter_name" {
  description = "The name of the SSM parameter to store IP addresses."
  type        = string
}
