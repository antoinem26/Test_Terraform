# modules/asg/main.tf
variable "ami_id" {
  description = "The AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t3.micro"
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

variable "ami_prefix" {
  description = "The AMI prefix"
  type        = string
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["${var.ami_prefix}*"]
  }
}

resource "aws_launch_template" "asg_template" {
  name_prefix = "asg-template-"
  image_id     = var.ami_id
  instance_type = var.instance_type
  key_name     = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.asg_min_size
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  vpc_zone_identifier  = var.subnets
  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "nginx-instance"  # Change selon l'ASG
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.example.arn]
}

resource "aws_launch_configuration" "example" {
  name          = "${var.ami_id}-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = var.asg_min_size
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.example.id

  tag {
    key                 = "Name"
    value               = var.ami_id
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "${var.ami_prefix}-lt"
  image_id      = data.aws_ami.selected.id
  instance_type = var.instance_type
  key_name      = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = var.asg_min_size
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  vpc_zone_identifier  = var.subnets
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.ami_prefix
    propagate_at_launch = true
  }
}

resource "aws_lb" "alb" {
  name               = "${var.ami_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.ami_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.lab_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.example.name
  alb_target_group_arn   = aws_lb_target_group.tg.arn
}
