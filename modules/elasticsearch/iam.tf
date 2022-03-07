data "aws_iam_policy_document" "es_cognito_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "cognito-idp:DescribeUserPool",
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:AdminInitiateAuth",
      "cognito-idp:AdminUserGlobalSignOut",
      "cognito-idp:ListUserPoolClients",
      "cognito-identity:DescribeIdentityPool",
      "cognito-identity:UpdateIdentityPool",
      "cognito-identity:SetIdentityPoolRoles",
      "cognito-identity:GetIdentityPoolRoles"
    ]
    resources = [
      "*",
    ]
  }
}

# policy allow es to access cognito
resource "aws_iam_policy" "es_cognito_policy" {
  name   = "${local.elastic_cluster_name_prefix}-es-acess-cognito-policy"
  policy = data.aws_iam_policy_document.es_cognito_policy_document.json
}

data "aws_iam_policy_document" "es_assume_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# iam role allow es to access cognito
resource "aws_iam_role" "es_access_cognito_role" {
  name               = "${local.elastic_cluster_name_prefix}-es-access-cognito-role"
  assume_role_policy = data.aws_iam_policy_document.es_assume_policy_document.json

  tags = var.common_tags
}

# attach the policy to the role
resource "aws_iam_role_policy_attachment" "es_cognito_attach" {
  role       = aws_iam_role.es_access_cognito_role.name
  policy_arn = aws_iam_policy.es_cognito_policy.arn
}

## if not created yet, the comment this block in
# resource "aws_iam_service_linked_role" "es" {
#   aws_service_name = "es.amazonaws.com"
# }

data "aws_iam_policy_document" "es_access_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${var.cognito_auth_arn}"]
    }
    actions   = ["es:*"]
    resources = ["arn:aws:es:${var.aws_region_name}:${var.aws_account_id}:domain/${local.elastic_cluster_name_prefix}-es/*"]
  }
}

