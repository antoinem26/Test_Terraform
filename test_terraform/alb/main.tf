variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "security_group" {
  description = "Security group for the ALB"
  type        = string
}

resource "aws_lb" "alb" {
  name               = "student-5-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group]
  subnets            = var.public_subnets

  enable_deletion_protection = false
}

output "alb_arn" {
  value = aws_lb.alb.arn
}