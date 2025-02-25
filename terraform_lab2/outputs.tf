output "public_dns" {
  value = module.ec2_instance.public_dns
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}
