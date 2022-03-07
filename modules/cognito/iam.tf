data "aws_iam_policy_document" "authenticated_assume_role_policy_documnet" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = ["${aws_cognito_identity_pool.identity_pool.id}"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}

resource "aws_iam_role" "authenticated" {
  name               = "${local.user_pool_name}-cognito-auth-role"
  assume_role_policy = data.aws_iam_policy_document.authenticated_assume_role_policy_documnet.json

  tags = var.common_tags
}


data "aws_iam_policy_document" "authenticated_role_policy_document" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["mobileanalytics:PutEvents", "cognito-sync:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "authenticated_role_policy" {
  name   = "${local.user_pool_name}-cognito-authenticated_role_policy"
  policy = data.aws_iam_policy_document.authenticated_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "authenticated_role_policy_attach" {
  role       = aws_iam_role.authenticated.name
  policy_arn = aws_iam_policy.authenticated_role_policy.arn
}


data "aws_iam_policy_document" "unauthenticated_assume_role_policy_documnet" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = ["${aws_cognito_identity_pool.identity_pool.id}"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
  }
}

resource "aws_iam_role" "unauthenticated" {
  name               = "${local.user_pool_name}-cognito-unauth-role"
  assume_role_policy = data.aws_iam_policy_document.unauthenticated_assume_role_policy_documnet.json

  tags = var.common_tags
}


data "aws_iam_policy_document" "unauthenticated_role_policy_document" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["mobileanalytics:PutEvents", "cognito-sync:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "unauthenticated_role_policy" {
  name   = "${local.user_pool_name}-cognito-unauthenticated_role_policy"
  policy = data.aws_iam_policy_document.unauthenticated_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "unauthenticated_role_policy_attach" {
  role       = aws_iam_role.unauthenticated.name
  policy_arn = aws_iam_policy.unauthenticated_role_policy.arn
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id
  roles = {
    "authenticated"   = aws_iam_role.authenticated.arn
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }
}
