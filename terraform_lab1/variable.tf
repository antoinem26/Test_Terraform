// filepath: /home/user/Test_Terraform/terraform_lab1/variables.tf
variable "image" {
  description = "Docker image to use"
  type        = string
  default     = "nginx:latest"
}

variable "container_memory" {
  description = "Memory limit for the container"
  type        = number
  default     = 512
}

variable "privileged" {
  description = "Run container in privileged mode"
  type        = bool
  default     = false
}

variable "container_count" {
  description = "Number of containers to spawn"
  type        = number
  default     = 1
}

variable "start_port" {
  description = "Starting port for the containers"
  type        = number
  default     = 3000
}