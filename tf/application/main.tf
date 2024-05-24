module "compute" {
  source = "../modules/compute"

  project_name         = local.project_name
  deploy_id            = local.deploy_id
  tenancy_ocid         = var.tenancy_ocid
  compartment_ocid     = var.compartment_ocid
  subnet_id            = oci_core_subnet.app_subnet.id
  instance_shape       = var.instance_shape
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key       = var.ssh_public_key
  db_url               = module.basedb.connection_string
  db_password          = module.basedb.db_password
}

module "basedb" {
  source = "../modules/basedb"

  project_name     = local.project_name
  deploy_id        = local.deploy_id
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  db_version = "23.0.0.0.0"
  subnet_ocid = oci_core_subnet.db_subnet.id
  ssh_public_key_content = var.ssh_public_key
  db_name = "${local.project_name}"
  pdb_name = "${local.project_name}pdb"
  display_name = "${local.project_name}"
  hostname = "${local.project_name}"
  db_storage_management = "LVM"
}

resource "random_string" "deploy_id" {
  length  = 2
  special = false
  upper   = false
}
