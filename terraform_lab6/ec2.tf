provider "aws" {
  region = "eu-west-3"
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
  tags = {
    Name = "student_5_11_Private"
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
  ami_id        = "ami-0bf560181632e3b98" 
  asg_min_size  = 2
  asg_max_size  = 2
  subnets       = [data.aws_subnet.private.id]
  security_group = data.aws_security_group.internal.id
  alb_arn        = data.aws_lb.alb.arn
}

# 📌 Déploiement du module ASG pour Tomcat (bitnami-tomcat)
module "tomcat_asg" {
  source        = "./modules/asg"
  ami_id        = "ami-0d9aeb69ab2a9ede6"  # Remplacer par l'AMI de Tomcat
  asg_min_size  = 2
  asg_max_size  = 2
  subnets       = [data.aws_subnet.private.id]
  security_group = data.aws_security_group.internal.id
  alb_arn        = data.aws_lb.alb.arn
}