variable "project_name" {
  type = string
}

variable "deploy_id" {
  type = string
}

variable "create_iam_policy" {
  type = bool
  default = true
}

variable "tenancy_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "db_url" {
  type = string
}

variable "db_password" {
  type = string
}

variable "shape_name" {
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
