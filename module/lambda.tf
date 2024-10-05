# lambda.tf

# Lambda function to resolve RDS Proxy IPs
resource "aws_lambda_function" "resolve_rds_proxy_ips" {
  function_name = "resolve_rds_proxy_ips"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"

  filename = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      RDS_PROXY_ENDPOINT = aws_db_proxy.this.endpoint
      SSM_PARAMETER_NAME = "/rds_proxy/ip_addresses"
    }
  }

  tags = local.common_tags
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-resolve-rds-proxy-ips"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = local.common_tags
}

# IAM Policy Document for Lambda Assume Role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Attach basic execution role policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM Policy for SSM access
resource "aws_iam_role_policy" "lambda_ssm_policy" {
  name   = "lambda-ssm-policy"
  role   = aws_iam_role.lambda_role.id

  policy = data.aws_iam_policy_document.lambda_ssm_policy.json
}

# IAM Policy Document for SSM access
data "aws_iam_policy_document" "lambda_ssm_policy" {
  statement {
    actions = [
      "ssm:PutParameter",
    ]

    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/rds_proxy/ip_addresses"]
  }
}

# Archive the Lambda function code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code"
  output_path = "${path.module}/lambda_code.zip"
}
