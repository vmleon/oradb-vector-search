
resource "random_string" "deploy_id" {
  length  = 2
  special = false
  upper   = false
}

// FIXME place ADB-S database within DB Subnet, and not public
module "adbs" {
  source = "../modules/adb-s"

  project_name           = local.project_name
  deploy_id              = local.deploy_id
  compartment_ocid       = var.compartment_ocid
}

module "backend" {
  source = "../modules/backend"

  project_name        = local.project_name
  deploy_id           = local.deploy_id
  config_file_profile = var.config_file_profile
  region              = var.region
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid

  subnet_id      = oci_core_subnet.app_subnet.id
  instance_shape = var.instance_shape
  ssh_public_key = var.ssh_public_key
  ads            = data.oci_identity_availability_domains.ads.availability_domains

  db_name                        = module.adbs.db_name
  db_admin_password              = module.adbs.admin_password
  wallet_par_full_path           = oci_objectstorage_preauthrequest.db_wallet_artifact_par.full_path
  ansible_backend_artifact_par_full_path = oci_objectstorage_preauthrequest.ansible_backend_artifact_par.full_path
  backend_jar_par_full_path              = oci_objectstorage_preauthrequest.backend_jar_artifact_par.full_path
}

module "web" {
  source = "../modules/web"

  project_name        = local.project_name
  deploy_id           = local.deploy_id
  config_file_profile = var.config_file_profile
  region              = var.region
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid

  subnet_id      = oci_core_subnet.app_subnet.id
  instance_shape = var.instance_shape
  ssh_public_key = var.ssh_public_key
  ads            = data.oci_identity_availability_domains.ads.availability_domains
}

module "compute" {
  source = "../modules/compute"

  project_name        = local.project_name
  deploy_id           = local.deploy_id
  config_file_profile = var.config_file_profile
  region              = var.region
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid

  subnet_id            = oci_core_subnet.app_subnet.id
  instance_shape       = var.instance_shape
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key       = var.ssh_public_key
  ads                  = data.oci_identity_availability_domains.ads.availability_domains

  backend_private_ip = module.backend.private_ip
  web_private_ip     = module.web.private_ip

  db_name             = module.adbs.db_name
  db_admin_password   = module.adbs.admin_password

  embedding_model_par = oci_objectstorage_preauthrequest.onnx_model_par.full_path
  hotels_dataset_par  = oci_objectstorage_preauthrequest.hotels_dataset_par.full_path
  os_credential_user  = oci_identity_user.db_user.name
  os_credential_token = oci_identity_auth_token.db_user_auth_token.token
  bucket_name         = oci_objectstorage_bucket.artifacts_bucket.name

  ansible_compute_artifact_par_full_path = oci_objectstorage_preauthrequest.ansible_compute_artifact_par.full_path

  ansible_backend_artifact_par_full_path = oci_objectstorage_preauthrequest.ansible_backend_artifact_par.full_path
  backend_jar_par_full_path              = oci_objectstorage_preauthrequest.backend_jar_artifact_par.full_path

  ansible_db_artifact_par_full_path = oci_objectstorage_preauthrequest.ansible_db_artifact_par.full_path

  ansible_web_artifact_par_full_path = oci_objectstorage_preauthrequest.ansible_web_artifact_par.full_path
  web_par_full_path                  = oci_objectstorage_preauthrequest.web_artifact_par.full_path

  wallet_par_full_path               = oci_objectstorage_preauthrequest.db_wallet_artifact_par.full_path
}
