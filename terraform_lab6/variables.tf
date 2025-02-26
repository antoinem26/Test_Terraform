variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "min_size" {
  description = "Taille minimale de l'ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Taille maximale de l'ASG"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Nom de la clé SSH pour les instances"
  type        = string
}

variable "ami_nginx" {
  description = "AMI ID pour NGINX"
  type        = string
}

variable "ami_tomcat" {
  description = "AMI ID pour Tomcat"
  type        = string
}