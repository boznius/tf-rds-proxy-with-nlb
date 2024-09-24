# main.tf

# Create an IAM Role for the Lambda Function
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.project_name}-${var.environment}-lambda-exec-role"

  # Allow Lambda service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

# Attach the AWSLambdaBasicExecutionRole policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create an IAM Policy to allow Lambda to put parameters in SSM Parameter Store
resource "aws_iam_policy" "lambda_ssm_policy" {
  name = "${var.project_name}-${var.environment}-lambda-ssm-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssm:PutParameter"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/${var.ssm_parameter_name}"
      }
    ]
  })
}

# Attach the custom SSM policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_ssm_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_ssm_policy.arn
}

# Create the Lambda Function to resolve RDS Proxy endpoint IP addresses
resource "aws_lambda_function" "resolve_rds_proxy_ips" {
  function_name = "${var.project_name}-${var.environment}-resolve-rds-proxy-ips"
  s3_bucket     = var.lambda_function_s3_bucket
  s3_key        = var.lambda_function_s3_key
  handler       = var.lambda_function_handler
  runtime       = var.lambda_function_runtime
  role          = aws_iam_role.lambda_execution_role.arn

  # Pass environment variables to the Lambda function
  environment {
    variables = {
      RDS_PROXY_ENDPOINT = var.rds_proxy_endpoint
      SSM_PARAMETER_NAME = var.ssm_parameter_name
    }
  }

  tags = local.common_tags
}

# Invoke the Lambda function after it's created
resource "null_resource" "invoke_lambda" {
  # Ensure that the Lambda function is created before invoking
  depends_on = [aws_lambda_function.resolve_rds_proxy_ips]

  # Use a local-exec provisioner to invoke the Lambda function
  provisioner "local-exec" {
    command = <<EOT
aws lambda invoke --function-name ${aws_lambda_function.resolve_rds_proxy_ips.function_name} /tmp/lambda_output.txt
EOT
  }
}

# Create a Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "${var.project_name}-${var.environment}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  tags               = local.common_tags
}

# Create a target group for the NLB
resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = 3306 # Replace with your database port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Using IP addresses as targets

  # Health check configuration
  health_check {
    protocol = "TCP"
  }

  tags = local.common_tags
}

# Attach the resolved RDS Proxy IP addresses as targets to the target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  for_each        = toset(local.rds_proxy_ips)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id       = each.value
  port            = 3306 # Replace with your database port
}

# Create a listener for the NLB
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 3306 # Replace with your database port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}
