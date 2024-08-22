data "archive_file" "ansible_compute_artifact" {
  type             = "zip"
  source_dir       = "${path.module}/../../ansible/compute"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_compute_artifact.zip"
}

data "archive_file" "ansible_backend_artifact" {
  type             = "zip"
  source_dir       = "${path.module}/../../ansible/backend"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_backend_artifact.zip"
}

data "archive_file" "backend_jar_artifact" {
  type             = "zip"
  source_file      = "${path.module}/../../src/vector/build/libs/vector-0.0.1.jar"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/backend_artifact.zip"
}

data "archive_file" "ansible_web_artifact" {
  type             = "zip"
  source_dir       = "${path.module}/../../ansible/web"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_web_artifact.zip"
}

data "archive_file" "web_artifact" {
  type             = "zip"
  source_dir       = "${path.module}/../../src/web/dist/"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/web_artifact.zip"
}

data "archive_file" "ansible_db_artifact" {
  type             = "zip"
  source_dir       = "${path.module}/../../ansible/db"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_db_artifact.zip"
}
