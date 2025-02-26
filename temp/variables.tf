variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to create the subnet in."
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet."
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet."
  type        = string
}

variable "subnet_name" {
  description = "The name tag for the subnet."
  type        = string
}
