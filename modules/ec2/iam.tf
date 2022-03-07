
data "aws_iam_policy_document" "ec2_access_es_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "es:*"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ec2_access_es_policy" {
  name   = "${var.project}-${var.system}-${var.environment}-ec2_access_es_policy"
  policy = data.aws_iam_policy_document.ec2_access_es_document.json
}

data "aws_iam_policy_document" "ec2_assume_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_access_es_role" {
  name               = "${var.project}-${var.system}-${var.environment}-ec2-access-es-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy_document.json

  description = "allows EC2 instances to call opensearch"

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_access_es_role_policy_attach" {
  role       = aws_iam_role.ec2_access_es_role.name
  policy_arn = aws_iam_policy.ec2_access_es_policy.arn
}

