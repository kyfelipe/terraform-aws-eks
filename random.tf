resource "random_id" "project_identifier" {
  keepers = {
    token = var.project
  }

  byte_length = 2
}
