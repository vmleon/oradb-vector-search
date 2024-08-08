locals {
  dynamic_group_name = "db_dynamic_group_${local.project_name}${local.deploy_id}"
  group_name         = "db_group_${local.project_name}${local.deploy_id}"
}

resource "oci_identity_group" "db_group" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "Group for ${local.group_name}"
  name           = local.group_name
}

resource "oci_identity_user" "db_user" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "User to download Objects from Storage"
  name           = "db_user_${local.project_name}${local.deploy_id}"

  email = "db_user_${local.project_name}${local.deploy_id}@example.com"
}

resource "oci_identity_auth_token" "db_user_auth_token" {
  provider    = oci.home
  description = "User Auth Token to download Objects from Storage"
  user_id     = oci_identity_user.db_user.id
}

resource "oci_identity_policy" "db_user_policy_in_tenancy" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  name           = "db_user_policies_tenancy_${local.project_name}${local.deploy_id}"
  description    = "Allow group ${local.group_name} to get objects from storage"
  statements = [
    "Allow group ${oci_identity_group.db_group.name} to read buckets in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.db_group.name} to read objects in compartment id ${var.compartment_ocid}"
  ]
}

resource "oci_identity_user_group_membership" "db_user_group_membership" {
  provider = oci.home
  group_id = oci_identity_group.db_group.id
  user_id  = oci_identity_user.db_user.id
}