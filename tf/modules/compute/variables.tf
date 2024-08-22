variable "project_name" {
  type = string
}

variable "deploy_id" {
  type = string
}

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

variable "subnet_id" {
  type = string
}


variable "ads" {
  type = list(any)
}

variable "embedding_model_par" {
  type = string
}

variable "hotels_dataset_par" {
  type = string
}

variable "os_credential_user" {
  type = string
}

variable "os_credential_token" {
  type      = string
  sensitive = true
}

variable "bucket_name" {
  type = string
}

variable "backend_private_ip" {
  type = string
}

variable "web_private_ip" {
  type = string
}

variable "db_home_location" {
  type = string
}

variable "db_private_ip" {
  type = string
}

variable "db_url" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_pdb_url" {
  type = string
}

variable "db_pdb_password" {
  type      = string
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

variable "ansible_compute_artifact_par_full_path" {
  type = string
}

variable "ansible_backend_artifact_par_full_path" {
  type = string
}

variable "backend_jar_par_full_path" {
  type = string
}

variable "ansible_db_artifact_par_full_path" {
  type = string
}

variable "web_par_full_path" {
  type = string
}

variable "ansible_web_artifact_par_full_path" {
  type = string
}
