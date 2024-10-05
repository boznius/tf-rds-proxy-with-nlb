############################################
# Network Load Balancer Setup
############################################

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
  port        = 5432 # PostgreSQL default port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Using IP addresses as targets

  # Health check configuration
  health_check {
    protocol = "TCP"
    port     = 5432 # PostgreSQL default port
  }

  tags = local.common_tags
}

# Attach the resolved RDS Proxy IP addresses as targets to the target group
resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  for_each         = toset(local.rds_proxy_ips)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = each.value
  port             = 5432 # PostgreSQL default port
}

# Create a listener for the NLB
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 5432 # PostgreSQL default port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

############################################
# Security Group Rules
############################################

# Allow traffic from NLB to RDS Proxy
resource "aws_security_group_rule" "allow_nlb_to_rds_proxy" {
  type                     = "ingress"
  from_port                = 5432 # PostgreSQL default port
  to_port                  = 5432 # PostgreSQL default port
  protocol                 = "tcp"
  security_group_id        = var.rds_proxy_security_group_ids[0]
  source_security_group_id = var.nlb_security_group_ids[0]
  description              = "Allow traffic from NLB to RDS Proxy"

  depends_on = [aws_lb_target_group_attachment.nlb_tg_attachment]
}
