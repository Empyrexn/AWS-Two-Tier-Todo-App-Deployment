output "web1_public_ip" {
  value = aws_instance.web1.public_ip
}

output "web2_public_ip" {
  value = aws_instance.web2.public_ip
}

output "alb_dns" {
  value = aws_lb.todo_alb.dns_name
}
