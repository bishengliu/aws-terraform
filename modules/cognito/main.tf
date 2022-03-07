resource "aws_cognito_user_pool" "user_pool" {
  name = "${local.user_pool_name}-user-pool"

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"
  username_attributes      = ["email"]

  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 30
  }

  tags = var.common_tags
}

resource "aws_cognito_user_pool_client" "client" {
  name = "user-client-${local.user_pool_name}"

  user_pool_id        = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.cognito_domain
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "${local.user_pool_name}-identity-pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }

  lifecycle { ignore_changes = [cognito_identity_providers] }

  tags = var.common_tags
}

# add users using aws cli
# https://github.com/hashicorp/terraform-provider-aws/issues/4542
resource "null_resource" "cognito_user" {

  triggers = {
    user_pool_id = aws_cognito_user_pool.user_pool.id
  }

  provisioner "local-exec" {
    command = "aws --region ${var.region} cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool.user_pool.id} --username ${var.master_username} --user-attributes Name=email,Value=${var.master_username}"
  }

  provisioner "local-exec" {
    command = "aws --region ${var.region} cognito-idp admin-set-user-password --user-pool-id ${aws_cognito_user_pool.user_pool.id} --username ${var.master_username} --password ${random_password.master_password.result} --permanent"
  }

}

