
resource "random_string" "deploy_id" {
  length  = 2
  special = false
  upper   = false
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
  ansible_db_artifact_par_full_path      = oci_objectstorage_preauthrequest.ansible_db_artifact_par.full_path
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

# module "adbd" {
#   source = "../modules/adbd"

#   project_name                           = local.project_name
#   deploy_id                              = local.deploy_id
#   tenancy_ocid                           = var.tenancy_ocid
#   compartment_ocid                       = var.compartment_ocid
#   adb_version_service_component          = var.adb_version_service_component
#   autonomous_container_database_version = var.autonomous_container_database_version
#   display_name                           = "${local.project_name}${local.deploy_id}"

#   subnet_ocid                            = oci_core_subnet.db_subnet.id
#   ads                                    = data.oci_identity_availability_domains.ads.availability_domains

#   autonomous_exadata_shape               = var.autonomous_exadata_shape
#   exadata_infrastructure_compute_count   = var.exadata_infrastructure_compute_count
#   exadata_infrastructure_storage_count   = var.exadata_infrastructure_storage_count
#   # db_name                 = "${local.project_name}${local.deploy_id}"
#   # pdb_name                = "${local.project_name}${local.deploy_id}pdb"
# }

# module "datascience" {
#   source = "../modules/datascience"

#   project_name            = local.project_name
#   deploy_id               = local.deploy_id
#   tenancy_ocid            = var.tenancy_ocid
#   compartment_ocid        = var.compartment_ocid
#   public_subnet_id        = oci_core_subnet.public_subnet.id
#   private_subnet_id       = oci_core_subnet.app_subnet.id  
#   shape_name              = var.datascience_shape
#   db_url                  = module.basedb.connection_string
#   db_password             = module.basedb.db_password
# }
