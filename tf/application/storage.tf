resource "oci_objectstorage_bucket" "artifacts_bucket" {
  compartment_id = var.compartment_ocid
  name           = "artifacts_${local.project_name}${local.deploy_id}"
  namespace      = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
}

resource "oci_objectstorage_object" "onnx_model_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = "${path.module}/../../all_MiniLM_L12_v2_augmented/all_MiniLM_L12_v2.onnx"
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "all_MiniLM_L12_v2.onnx"
}

resource "oci_objectstorage_preauthrequest" "onnx_model_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "onnx_model_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.onnx_model_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "hotels_dataset_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = "${path.module}/../../dataset/hotels.zip"
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "hotels.zip"
}

resource "oci_objectstorage_preauthrequest" "hotels_dataset_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "hotels_dataset_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.hotels_dataset_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "ansible_compute_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.ansible_compute_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "ansible_compute_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "ansible_compute_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "ansible_compute_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.ansible_compute_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "ansible_backend_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.ansible_backend_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "ansible_backend_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "ansible_backend_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "ansible_backend_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.ansible_backend_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "backend_jar_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.backend_jar_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "backend_jar_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "backend_jar_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "backend_jar_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.backend_jar_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "ansible_web_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.ansible_web_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "ansible_web_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "ansible_web_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "ansible_web_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.ansible_web_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "web_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.web_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "web_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "web_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "web_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.web_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}

resource "oci_objectstorage_object" "ansible_db_artifact_object" {
  bucket    = oci_objectstorage_bucket.artifacts_bucket.name
  source    = data.archive_file.ansible_db_artifact.output_path
  namespace = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  object    = "ansible_db_artifact.zip"
}

resource "oci_objectstorage_preauthrequest" "ansible_db_artifact_par" {
  namespace    = data.oci_objectstorage_namespace.objectstorage_namespace.namespace
  bucket       = oci_objectstorage_bucket.artifacts_bucket.name
  name         = "ansible_db_artifact_par"
  access_type  = "ObjectRead"
  object_name  = oci_objectstorage_object.ansible_db_artifact_object.object
  time_expires = timeadd(timestamp(), "${var.artifacts_par_expiration_in_days * 24}h")
}
