# nlb_target_group.tf

resource "aws_lb_target_group" "this" {
  name        = "rds-proxy-target-group"
  port        = local.rds_proxy_port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  tags = local.common_tags
}

# Target group attachments using the IPs from SSM
resource "aws_lb_target_group_attachment" "this" {
  count            = length(local.rds_proxy_ip_addresses)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = local.rds_proxy_ip_addresses[count.index]
  port             = local.rds_proxy_port
}
