variable "ami_id" {
  description = "The AMI ID"
  type        = string
}

variable "asg_min_size" {
  description = "The minimum size of the AutoScaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size of the AutoScaling Group"
  type        = number
}

variable "subnets" {
  description = "The subnets for the AutoScaling Group"
  type        = list(string)
}

variable "security_group" {
  description = "The security group for the AutoScaling Group"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t3.micro"
}

variable "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  type        = string
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
}

resource "aws_launch_template" "lt" {
  name_prefix   = "student-11-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data

  lifecycle {
    create_before_destroy = true
  }
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