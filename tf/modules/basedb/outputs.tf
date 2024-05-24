output "db_service" {
  value = "${var.project_name}${var.deploy_id}"
}

output "db_password" {
  value     = random_password.db_admin_password.result
  sensitive = true
}

output "db_edition" {
  value = oci_database_db_system.db_system.database_edition
}

output "db_home_location" {
  value = oci_database_db_system.db_system.db_home[0].db_home_location
}

output "private_ip" {
  value = oci_database_db_system.db_system.private_ip
}

output "db_version" {
  value = oci_database_db_system.db_system.version
}

output "shape" {
  value = oci_database_db_system.db_system.shape
}

output "connection_string" {
  value = oci_database_db_system.db_system.db_home[0].database[0].connection_strings[0].cdb_default
}
