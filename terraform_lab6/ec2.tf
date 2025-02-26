provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 📌 Récupère le VPC existant "Lab5-6" créé par l'étudiant X
data "aws_vpc" "lab_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# 📌 Récupère les sous-réseaux privés créés par l'étudiant X (student-5)
data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["student_5_11_Private"]
  }
}

# 📌 Récupère le groupe de sécurité interne créé par l'étudiant X
data "aws_security_group" "internal" {
  filter {
    name   = "tag:Name"
    values = ["internal"]
  }
}

# 📌 Récupère l'ALB créé par l'étudiant X (student-5)
data "aws_lb" "alb" {
  name = "student-5-alb"
}

# 📌 Déploiement du module ASG pour Nginx (bitnami-nginx)
module "nginx_asg" {
  source        = "./modules/asg"
  ami_id        = var.ami_nginx
  asg_min_size  = var.min_size
  asg_max_size  = var.max_size
  key_name      = var.key_name
  subnets       = [data.aws_subnet.private.id]
  security_group = data.aws_security_group.internal.id
  alb_arn       = data.aws_lb.alb.arn
  user_data     = base64encode("#!/bin/bash\necho 'Hello, Nginx!' > /var/www/html/index.html")
}

# 📌 Déploiement du module ASG pour Tomcat (bitnami-tomcat)
module "tomcat_asg" {
  source        = "./modules/asg"
  ami_id        = var.ami_tomcat
  asg_min_size  = var.min_size
  asg_max_size  = var.max_size
  key_name      = var.key_name
  subnets       = [data.aws_subnet.private.id]
  security_group = data.aws_security_group.internal.id
  alb_arn       = data.aws_lb.alb.arn
  user_data     = base64encode("#!/bin/bash\necho 'Hello, Tomcat!' > /var/www/html/index.html")
}
