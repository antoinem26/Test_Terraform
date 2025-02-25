terraform {
  backend "s3" {
    bucket         = "terraform-state-qh2o7"
    key            = "global/s3/student_11/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "ec2_instance" {
  source = "./module"

  aws_region      = var.aws_region
  aws_access_key  = var.aws_access_key
  aws_secret_key  = var.aws_secret_key
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  ami             = var.ami
  key_name        = var.key_name
  public_key_path = var.public_key_path
  instance_type   = var.instance_type
  instance_name   = var.instance_name
}
