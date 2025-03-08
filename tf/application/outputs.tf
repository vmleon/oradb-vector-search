output "deployment" {
  value = "${local.project_name}${local.deploy_id}"
}

output "instance_private_ip" {
  value = module.compute.private_ip
}

output "app_bastion_id" {
  value = module.compute.bastion_id
}

output "db_name" {
  value = module.adbs.db_name
}

output "db_admin_password" {
  value     = module.adbs.admin_password
  sensitive = true
}
output "instance_id" {
  sensitive = true
  value     = module.compute.id
}

output "instance_name" {
  sensitive = false
  value     = module.compute.name
}

output "lb_ip" {
  value = oci_core_public_ip.public_reserved_ip.ip_address
}
