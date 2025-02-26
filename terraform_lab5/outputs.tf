output "private_subnet_id" {
  value = data.aws_subnet.private_subnet.id
}

output "internal_sg_id" {
  value = data.aws_security_group.internal_sg.id
}

output "nginx_asg_name" {
  value = aws_autoscaling_group.nginx.name
}

output "tomcat_asg_name" {
  value = aws_autoscaling_group.tomcat.name
}

output "alb_arn" {
  value = aws_lb.alb.arn
}