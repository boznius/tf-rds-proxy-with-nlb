# data.tf

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnet IDs in the default VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Get the current AWS region
data "aws_region" "current" {}

# Get the current AWS account ID
data "aws_caller_identity" "current" {}
