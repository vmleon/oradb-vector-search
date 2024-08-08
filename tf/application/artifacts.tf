data "archive_file" "ansible_compute_artifact" {
  type             = "zip"
  source_dir      = "${path.module}/../../ansible/compute"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_compute_artifact.zip"
}

data "archive_file" "ansible_db_artifact" {
  type             = "zip"
  source_dir      = "${path.module}/../../ansible/db"
  output_file_mode = "0666"
  output_path      = "${path.module}/generated/ansible_db_artifact.zip"
}
