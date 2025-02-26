variable "ami_prefix" {
  description = "The AMI prefix"
  type        = string
}

variable "asg_min_size" {
  description = "The minimum size of the AutoScaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size of the AutoScaling Group"
  type        = number
}

variable "subnets" {
  description = "The subnets for the AutoScaling Group"
  type        = list(string)
}

variable "security_group" {
  description = "The security group for the AutoScaling Group"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t3.micro"
}