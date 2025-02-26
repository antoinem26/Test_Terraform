variable "ami_id" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "subnets" {}
variable "security_group" {}
variable "alb_arn" {}

resource "aws_launch_template" "lt" {
  name_prefix   = "student-11-lt"
  image_id      = var.ami_id
  instance_type = "t3.micro"

  user_data = <<-EOT
              #!/bin/bash
              echo "User Data for EC2 instance"
              EOT
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.asg_min_size
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  vpc_zone_identifier  = var.subnets
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  
  health_check_type        = "EC2"
  health_check_grace_period = 300
  load_balancers           = [var.alb_arn]

  tag {
    key                 = "Name"
    value               = "student-11-ASG"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "asg_id" {
  value = aws_autoscaling_group.asg.id
}