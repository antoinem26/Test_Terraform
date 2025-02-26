provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 📌 Récupère le subnet privé créé par un autre étudiant
data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["student_X_private"]
  }
}

# 📌 Récupère le Security Group interne créé par un autre étudiant
data "aws_security_group" "internal_sg" {
  filter {
    name   = "tag:Name"
    values = ["internal"]
  }
}

# 📌 Récupère l'AMI pour Nginx
data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["bitnami-nginx-1.26.3*"]
  }
}

# 📌 Récupère l'AMI pour Tomcat
data "aws_ami" "tomcat" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["bitnami-tomcat-10.1.34*"]
  }
}

# 📌 Création du Launch Template pour Nginx
resource "aws_launch_template" "nginx" {
  name_prefix   = "nginx-lt"
  image_id      = var.ami_nginx
  instance_type = "t3.micro"
  key_name      = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

# 📌 Création du Launch Template pour Tomcat
resource "aws_launch_template" "tomcat" {
  name_prefix   = "tomcat-lt"
  image_id      = var.ami_tomcat
  instance_type = "t3.micro"
  key_name      = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

# 📌 Création de l'ASG pour Nginx
resource "aws_autoscaling_group" "nginx" {
  desired_capacity     = var.min_size
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = [data.aws_subnet.private_subnet.id]
  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nginx-asg"
    propagate_at_launch = true
  }
}

# 📌 Création de l'ASG pour Tomcat
resource "aws_autoscaling_group" "tomcat" {
  desired_capacity     = var.min_size
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = [data.aws_subnet.private_subnet.id]
  launch_template {
    id      = aws_launch_template.tomcat.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tomcat-asg"
    propagate_at_launch = true
  }
}

# 📌 Création de l'ALB
resource "aws_lb" "alb" {
  name               = "student-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.internal_sg.id]
  subnets            = [data.aws_subnet.private_subnet.id]

  enable_deletion_protection = false
}

# 📌 Création du Target Group pour Nginx
resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.private_subnet.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# 📌 Création du Target Group pour Tomcat
resource "aws_lb_target_group" "tomcat_tg" {
  name     = "tomcat-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.private_subnet.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# 📌 Création du Listener pour Nginx
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# 📌 Création du Listener pour Tomcat
resource "aws_lb_listener" "tomcat_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tomcat_tg.arn
  }
}

# 📌 Attachement de l'ASG Nginx au Target Group
resource "aws_autoscaling_attachment" "nginx_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.nginx.name
  lb_target_group_arn    = aws_lb_target_group.nginx_tg.arn
}

# 📌 Attachement de l'ASG Tomcat au Target Group
resource "aws_autoscaling_attachment" "tomcat_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tomcat.name
  lb_target_group_arn    = aws_lb_target_group.tomcat_tg.arn
}