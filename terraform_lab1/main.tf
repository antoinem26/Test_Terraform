terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "nginx" {
  count = var.container_count

  image      = docker_image.nginx.name
  name       = "nginx_container_${count.index}"
  memory     = var.container_memory
  privileged = var.privileged

  ports {
    internal = 80
    external = var.start_port + count.index
  }

  provisioner "local-exec" {
    command = <<EOT
      docker exec nginx_container_${count.index} sh -c 'echo "Welcome to $(hostname)" > /usr/share/nginx/html/index.html'
    EOT
  }
}