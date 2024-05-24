locals {
  cloud_init_content = templatefile("${path.module}/userdata/bootstrap.tftpl", {
    db_url        = var.db_url
    db_password   = var.db_password
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
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[0], "name")
  compartment_id = var.compartment_ocid
  display_name   = "${var.project_name}${var.deploy_id}"
  shape          = var.instance_shape

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
  create_duration = "2m"
}
