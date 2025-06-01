output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "app_instance_ips" {
  value = aws_instance.app[*].public_ip
}
