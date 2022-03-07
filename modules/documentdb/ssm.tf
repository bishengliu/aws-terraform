resource "aws_ssm_parameter" "ssm_parameters" {
  for_each = {
    master_password = random_password.master_password.result,
    master_username = local.master_username,
    password        = random_password.password.result,
    username        = local.app_username,
    endpoint        = aws_docdb_cluster.docdb.endpoint
  }
  name      = "/application/${var.project}/${var.system}/${var.environment}/latest/database_${each.key}"
  type      = "SecureString"
  value     = each.value
  overwrite = true
  tags      = var.common_tags
}


resource "random_password" "master_password" {
  length           = 16
  special          = local.use_special_characters_in_passwords
  override_special = local.allowed_password_special_characters
  keepers = {
    pass_version = 1
  }
}

resource "random_password" "password" {
  length           = 16
  special          = local.use_special_characters_in_passwords
  override_special = local.allowed_password_special_characters
  keepers = {
    pass_version = 1
  }
}

locals {
  master_username                     = "${replace(var.system, "-", "_")}_db_admin"
  app_username                        = "${replace(var.system, "-", "_")}_db_app"
  allowed_password_special_characters = ")(-_=+<>}{*&"
  use_special_characters_in_passwords = true
}
