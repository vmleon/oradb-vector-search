variable "tenancy_ocid" {
  type = string
}

variable "region" {
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

variable "datascience_shape" {
  type = string
}

variable "notebook_ocpus" {
  type = number
  default = 1
}

variable "notebook_memory_in_gbs" {
  type = number
  default = 16
}
