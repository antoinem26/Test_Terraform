// filepath: /home/user/Test_Terraform/terraform_lab1/variables.tf
variable "image" {
  description = "Docker image to use"
  type        = string
  default     = "nginx:latest"
  validation {
    condition     = can(regex("^.+:.+$", var.image))
    error_message = "The image must be in the format 'repository:tag'."
  }
}

variable "container_memory" {
  description = "Memory limit for the container"
  type        = number
  default     = 512
  validation {
    condition     = var.container_memory > 0
    error_message = "Memory must be greater than 0."
  }
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
  validation {
    condition     = var.container_count > 0
    error_message = "Container count must be greater than 0."
  }
}

variable "start_port" {
  description = "Starting port for the containers"
  type        = number
  default     = 3001
  validation {
    condition     = var.start_port > 0
    error_message = "Start port must be greater than 0."
  }
}