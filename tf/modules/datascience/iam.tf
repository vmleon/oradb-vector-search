# resource "oci_identity_policy" "datascience_vcn_policy" {
#   count          = var.create_iam_policy ? 1 : 0
#   compartment_id = var.tenancy_ocid
#   description    = "Allow Data Science service to access VCN in compartment for  ${var.project_name}${var.deploy_id}"
#   name           = "ds-access-vcn-${var.project_name}${var.deploy_id}"
#   statements     = ["Allow service datascience to use virtual-network-family in compartment id ${var.compartment_ocid}"]
# }

locals {
  dynamic_group_name = "dg-${var.project_name}${var.deploy_id}"
}

resource "oci_identity_dynamic_group" "dynamic_group" {
  compartment_id = var.tenancy_ocid
  description    = "Data Science Dynamic Group for ${var.project_name}${var.deploy_id}"
  matching_rule  = "ALL { resource.type = 'datasciencenotebooksession', instance.compartment.id = '${var.compartment_ocid}' }"
  name           = local.dynamic_group_name
}

resource "oci_identity_policy" "datascience_dg_policy" {
  count          = var.create_iam_policy ? 1 : 0
  compartment_id = var.tenancy_ocid
  description    = "Allow Data Science service to access VCN in compartment for  ${var.project_name}${var.deploy_id}"
  name           = "ds-access-${var.project_name}${var.deploy_id}"
  statements     = [
        "allow service datascience to use virtual-network-family in compartment id ${var.compartment_ocid}",
        "allow dynamic-group ${local.dynamic_group_name} to manage data-science-family in compartment id ${var.compartment_ocid}"
        # "allow group <data-scientists> to use virtual-network-family in compartment id ${var.compartment_ocid}",
        # "allow group <data-scientists> to manage data-science-family in compartment id ${var.compartment_ocid}",
    ]
}