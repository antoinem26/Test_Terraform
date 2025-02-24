// filepath: /home/user/Test_Terraform/terraform_lab1/outputs.tf
output "container_ids" {
  value = [for c in docker_container.nginx : c.id]
}

output "container_ips" {
  value = [for c in docker_container.nginx : c.ip_address]
}

output "container_ports" {
  value = [for c in docker_container.nginx : c.ports]
}