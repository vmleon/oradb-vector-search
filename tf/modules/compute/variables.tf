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

variable "subnet_id" {
  type = string
}

variable "db_url" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "instance_shape" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "ssh_public_key" {
  type = string
}