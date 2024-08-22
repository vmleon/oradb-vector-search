locals {
  cloud_init_content = templatefile("${path.module}/userdata/bootstrap.tftpl", {
    project_name                  = var.project_name
    db_url                        = var.db_url
    db_password                   = var.db_password
    db_service                    = "${var.project_name}${var.deploy_id}"
    db_pdb_url                    = var.db_pdb_url
    db_private_ip                 = var.db_private_ip
    private_key_content           = file(var.ssh_private_key_path)
    db_pdb_password               = var.db_pdb_password
    db_home_location              = var.db_home_location
    backend_private_ip            = var.backend_private_ip
    web_private_ip                = var.web_private_ip
    embedding_model_par           = var.embedding_model_par
    hotels_dataset_par            = var.hotels_dataset_par
    os_credential_user            = var.os_credential_user
    region_name                   = var.region
    os_namespace                  = data.oci_objectstorage_namespace.os_namespace.namespace
    bucket_name                   = var.bucket_name
    os_credential_token           = var.os_credential_token
    ansible_compute_par_full_path = var.ansible_compute_artifact_par_full_path
    backend_jar_par_full_path     = var.backend_jar_par_full_path
    ansible_backend_par_full_path = var.ansible_backend_artifact_par_full_path
    ansible_db_par_full_path      = var.ansible_db_artifact_par_full_path
    web_par_full_path             = var.web_par_full_path
    ansible_web_par_full_path     = var.ansible_web_artifact_par_full_path
  })
}

data "oci_core_images" "ol8_images" {
  compartment_id           = var.compartment_ocid
  shape                    = var.instance_shape
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "instance" {
  availability_domain = lookup(var.ads[0], "name")
  compartment_id      = var.compartment_ocid
  display_name        = "${var.project_name}${var.deploy_id}"
  shape               = var.instance_shape

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(local.cloud_init_content)
  }

  agent_config {
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  shape_config {
    ocpus         = 1
    memory_in_gbs = 16
  }

  create_vnic_details {
    subnet_id                 = var.subnet_id
    assign_public_ip          = false
    display_name              = "${var.project_name}${var.deploy_id}"
    assign_private_dns_record = true
    hostname_label            = "${var.project_name}${var.deploy_id}"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol8_images.images[0].id
  }

  timeouts {
    create = "60m"
  }
}

resource "time_sleep" "wait_for_instance" {
  depends_on      = [oci_core_instance.instance]
  create_duration = "3m"
}
