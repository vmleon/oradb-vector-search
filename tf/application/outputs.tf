output "deployment" {
  value = "${local.project_name}${local.deploy_id}"
}

output "instance_private_ip" {
  value = module.compute.private_ip
}

output "bastion_id" {
  value = module.compute.bastion_id
}

output "instance_id" {
  sensitive = true
  value = module.compute.id
}

output "instance_name" {
  sensitive = false
  value = module.compute.name
}

output "db_url" {
  value = module.basedb.connection_string
  sensitive = false
}

output "db_password" {
  value     = module.basedb.db_password
  sensitive = true
}

output "datascience_notebook_session_url" {
  value = module.datascience.ds_notebook_session_url
}