variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "security_group" {
  description = "Security group for the ALB"
  type        = string
}