provider "aws" {
  region = "eu-west-3"
}

# 📌 Récupère le VPC existant "Lab5-6"
data "aws_vpc" "lab_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Lab5-6"]
  }
}

# 📌 Récupère les AZ disponibles en eu-west-3
data "aws_availability_zones" "available" {}

# 📌 Création des subnets publics et privés
resource "aws_subnet" "public_a" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "student_5_11_Public_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.13.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "student_5_11_Public_b"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.lab_vpc.id
  cidr_block        = "192.168.113.0/24"
  availability_zone = "eu-west-3c"

  tags = {
    Name = "student_5_11_Private"
  }
}

# 📌 Security Group Public (Autorise HTTP et HTTPS depuis Internet)
resource "aws_security_group" "public" {
  vpc_id = data.aws_vpc.lab_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public"
  }
}

# 📌 Security Group Interne (Autorise uniquement le trafic du SG public)
resource "aws_security_group" "internal" {
  vpc_id = data.aws_vpc.lab_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  tags = {
    Name = "internal"
  }
}

# 📌 Appel du module ALB
module "alb" {
  source = "./modules/alb"
  public_subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
  security_group = aws_security_group.public.id
}