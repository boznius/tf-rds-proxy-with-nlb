# outputs.tf

output "rds_proxy_ip_addresses" {
  description = "List of RDS Proxy IP addresses resolved by the Lambda function."
  value       = local.rds_proxy_ip_addresses
}

output "rds_proxy_endpoint" {
  description = "The endpoint of the RDS Proxy."
  value       = aws_db_proxy.this.endpoint
}

output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer."
  value       = aws_lb.this.dns_name
}
