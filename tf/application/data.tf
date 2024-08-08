data "oci_identity_tenancy" "tenant_details" {
  tenancy_id = var.tenancy_ocid

  provider = oci
}

data "oci_identity_regions" "home" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }

  provider = oci
}

data "oci_objectstorage_namespace" "objectstorage_namespace" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_services" "all_services" {
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# data "oci_database_autonomous_container_database_versions" "autonomous_container_database_versions" {
#     compartment_id = var.compartment_ocid
#     service_component = var.adb_version_service_component
# }