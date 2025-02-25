variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
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
}

variable "subnet_id" {
  description = "The Subnet ID"
  type        = string
}

variable "ami" {
  description = "The AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}
