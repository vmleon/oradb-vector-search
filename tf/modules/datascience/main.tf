resource "oci_datascience_project" "project" {
  compartment_id = var.compartment_ocid

  description  = "Project ${var.project_name}${var.deploy_id}"
  display_name = "${var.project_name}${var.deploy_id}"
}

resource "oci_datascience_notebook_session" "notebook_session" {
  compartment_id = var.compartment_ocid
  project_id     = oci_datascience_project.project.id

  display_name = "Session ${var.project_name}${var.deploy_id}"
  
  notebook_session_runtime_config_details {
    custom_environment_variables = {
        "DB_URL" = var.db_url, 
        "DB_PASSWORD" = var.db_password
      }
  }

  notebook_session_configuration_details {
    shape = var.shape_name

    notebook_session_shape_config_details {
      memory_in_gbs = var.notebook_memory_in_gbs
      ocpus         = var.notebook_ocpus
    }

    subnet_id           = var.public_subnet_id
  }
}