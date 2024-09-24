# outputs.tf

# Output the list of RDS Proxy IP addresses
output "rds_proxy_ip_addresses" {
  description = "The IP addresses of the RDS Proxy resolved by Lambda and stored in SSM Parameter Store."
  value       = local.rds_proxy_ips
}

# Output the RDS Proxy endpoint
output "rds_proxy_endpoint" {
  description = "The endpoint of the RDS Proxy."
  value       = aws_db_proxy.rds_proxy.endpoint
}

# Output the NLB DNS name
output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer."
  value       = aws_lb.nlb.dns_name
}
