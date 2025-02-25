variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "eu-west-3"
}

variable "aws_access_key" {
  description = "The AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "The AWS secret key"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = "vpc-04e7fa58d477c06b7"
}

variable "subnet_id" {
  description = "The Subnet ID"
  type        = string
  default     = "subnet-0d4c3122cb0327eb2"
}

variable "ami" {
  description = "The AMI ID"
  type        = string
  default     = "ami-0446057e5961dfab6"
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the SSH key"
  type        = string
  default     = "my-key-pair"
}

variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
  default     = "/home/user/.ssh/id_rsa.pub"
}