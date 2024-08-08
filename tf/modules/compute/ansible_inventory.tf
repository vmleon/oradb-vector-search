resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible_inventory.tftpl",
    {
      db_hostname   = var.project_name
      db_private_ip  = var.db_private_ip
    }
  )
  filename = "${path.module}/generated/db.ini"
}