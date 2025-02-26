provider "aws" {
  region = var.aws_region
}

resource "aws_subnet" "example" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_name
  }
}
