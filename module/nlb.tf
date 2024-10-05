# nlb.tf

resource "aws_lb" "this" {
  name               = "my-rds-proxy-nlb"
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.default.ids

  tags = local.common_tags
}

# Listener for the NLB
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = local.rds_proxy_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
