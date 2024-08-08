variable "tenancy_ocid" {
  type = string
}

variable "region" {
  type = string
}

variable "config_file_profile" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "project_name" {
  type    = string
  default = "basedb"
}

variable "instance_shape" {
  type = string
}

variable "artifacts_par_expiration_in_days" {
  type    = number
  default = 7
}

variable "base_db_shape" {
  type = string
}

# variable "autonomous_exadata_shape" {
#   type    = string
#   default = "Exadata.X9M"
# }

# variable "adb_version_service_component" {
#   type = string
#   description = "ADBD, EXACC"
#   default = "ADBD"
# }

# variable "autonomous_container_database_version" {
#   type = string
# }

# variable "exadata_infrastructure_compute_count" {
#   type    = number
#   default = 2
# }

# variable "exadata_infrastructure_storage_count" {
#   type    = number
#   default = 3
# }

# variable "datascience_shape" {
#   type = string
# }

# variable "notebook_ocpus" {
#   type = number
#   default = 1
# }

# variable "notebook_memory_in_gbs" {
#   type = number
#   default = 16
# }
