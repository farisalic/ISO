output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
