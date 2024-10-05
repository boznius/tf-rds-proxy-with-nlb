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

# Subnet IDs for deploying resources
variable "subnet_ids" {
  description = "List of subnet IDs for the NLB and Lambda function."
  type        = list(string)
}

# Subnet IDs for RDS instance and RDS Proxy
variable "rds_subnet_ids" {
  description = "List of subnet IDs for the RDS instance and RDS Proxy."
  type        = list(string)
}

# Security group IDs for the RDS instance
variable "rds_instance_security_group_ids" {
  description = "List of security group IDs for the RDS instance."
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

# RDS Proxy name
variable "rds_proxy_name" {
  description = "Name of the RDS Proxy."
  type        = string
}

# Database configurations
variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "database_engine" {
  description = "The database engine to use (e.g., mysql, postgres)."
  type        = string
}

variable "database_engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "database_instance_class" {
  description = "The instance class to use for the database."
  type        = string
}

variable "database_username" {
  description = "The username for the master DB user."
  type        = string
}

variable "database_password" {
  description = "The password for the master DB user."
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "The allocated storage in GBs."
  type        = number
}

variable "storage_type" {
  description = "The storage type to use."
  type        = string
  default     = "gp2"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = bool
  default     = false
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
