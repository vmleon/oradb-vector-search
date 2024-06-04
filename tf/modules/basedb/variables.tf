variable "project_name" {
  type = string
}

variable "deploy_id" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "db_workload" {
  type    = string
  description = "OLTP, DW"
  default = "OLTP"
}

variable "cpu_core_count" {
  default = 1
  type    = number
}

variable "data_storage_size_in_tbs" {
  default = 1
  type    = number
}

variable "license_model" {
  type    = string
  description = "BRING_YOUR_OWN_LICENSE, LICENSE_INCLUDED"
  default = "BRING_YOUR_OWN_LICENSE"
}

// oci db version list --compartment-id
variable "db_version" {
  default = null
  type    = string
}


variable "subnet_ocid" {
  type = string
}

variable "db_edition" {
  type = string
  description = "STANDARD_EDITION, ENTERPRISE_EDITION, ENTERPRISE_EDITION_HIGH_PERFORMANCE, ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
  default = "STANDARD_EDITION"
}

variable "db_name" {
  type = string
}

variable "display_name" {
  type = string
}

variable "pdb_name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "enable_auto_backup" {
  type = bool
  default = true
}

variable "ssh_public_key_content" {
  type = string
}

variable "node_count" {
  type = number
  default = 1
}

variable "data_storage_size_in_gb" {
  type = number
  default = 256
}

variable "disk_redundancy" {
  type = string
  description = "NORMAL, HIGH"
  default = "NORMAL"
}

variable "storage_volume_performance_mode" {
  type = string
  description = "BALANCED, HIGH_PERFORMANCE"
  default = "BALANCED"
}

variable "db_storage_management" {
  type = string
  description = "LVM, ASM"
  default = "LVM"
}

// oci db system-shape list --compartment-id
variable "shape" {
  type = string
  default = "VM.Standard.E4.Flex"
}