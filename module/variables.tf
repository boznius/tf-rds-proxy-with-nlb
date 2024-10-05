# variables.tf

variable "engine" {
  description = "The database engine for the RDS Proxy. Valid values are 'mysql', 'postgresql', 'aurora'"
  type        = string
  default     = "mysql"
}

variable "rds_proxy_target_arn" {
  description = "The ARN of the RDS database or cluster to connect the proxy to."
  type        = string
}

variable "rds_proxy_iam_auth_role_arn" {
  description = "The IAM role ARN that the RDS Proxy will use for IAM authentication."
  type        = string
}

variable "rds_proxy_secrets" {
  description = "List of AWS Secrets Manager ARNs for the database credentials."
  type        = list(string)
}

variable "common_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
