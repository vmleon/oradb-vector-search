
resource "random_string" "deploy_id" {
  length  = 2
  special = false
  upper   = false
}

module "basedb" {
  source = "../modules/basedb"

  project_name           = local.project_name
  deploy_id              = local.deploy_id
  tenancy_ocid           = var.tenancy_ocid
  config_file_profile    = var.config_file_profile
  region                 = var.region
  compartment_ocid       = var.compartment_ocid
  ads                    = data.oci_identity_availability_domains.ads.availability_domains
  db_version             = "23.0.0.0.0"
  db_edition             = "ENTERPRISE_EDITION"
  shape                  = var.base_db_shape
  db_name                = "${local.project_name}${local.deploy_id}"
  pdb_name               = "${local.project_name}${local.deploy_id}pdb"
  display_name           = "${local.project_name}${local.deploy_id}"
  hostname               = local.project_name
  db_storage_management  = "LVM"
  ssh_public_key_content = var.ssh_public_key
  subnet_ocid            = oci_core_subnet.db_subnet.id
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

  db_home_location = module.basedb.db_home_location
  db_private_ip    = module.basedb.private_ip
  db_url           = module.basedb.connection_string
  db_password      = module.basedb.db_password
  db_pdb_url       = module.basedb.pdb_connection_string
  db_pdb_password  = module.basedb.db_pdb_password

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
}
