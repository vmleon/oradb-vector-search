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

variable "cert_fullchain" {
  type = string
}

variable "cert_private_key" {
  type = string
}