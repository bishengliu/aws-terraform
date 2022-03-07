resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "-_=+}{"
  number           = true
  lower            = true
  upper            = true
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  min_special      = 1
  keepers = {
    pass_version = 1
  }
}

resource "aws_ssm_parameter" "ssm_parameters" {
  for_each = {
    master_password = random_password.master_password.result,
    master_username = var.master_username,
  }
  name      = "/application/${var.project}/${var.system}/${var.environment}/userpool/auto_created_${each.key}"
  type      = "SecureString"
  value     = each.value
  overwrite = true

  tags = var.common_tags
}
