resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${local.elastic_cluster_name_prefix}-es"
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type  = var.elastic_nodes_type
    instance_count = var.elastic_nodes_count

    zone_awareness_enabled = var.elastic_nodes_az_count > 1 ? true : false

    dynamic "zone_awareness_config" {
      for_each = var.elastic_nodes_az_count > 1 ? [1] : []
      content {
        availability_zone_count = var.elastic_nodes_az_count
      }
    }

    dedicated_master_count = 0
  }

  ebs_options {
    ebs_enabled = var.elastic_nodes_ebs_enabled
    volume_size = var.elastic_nodes_ebs_volume_size
  }

  vpc_options {
    subnet_ids = var.elastic_nodes_az_count > 1 ? var.subnet_ids : [sort(var.subnet_ids)[0]]

    security_group_ids = [aws_security_group.es.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  access_policies = data.aws_iam_policy_document.es_access_policy.json

  cognito_options {
    enabled          = true
    user_pool_id     = var.user_pool_id
    identity_pool_id = var.identity_pool_id
    role_arn         = aws_iam_role.es_access_cognito_role.arn
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.lg.arn
    enabled                  = true
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  tags = var.common_tags

  depends_on = [var.es_service_linked_role, aws_iam_role_policy_attachment.es_cognito_attach]
}

resource "aws_security_group" "es" {
  name        = "${var.vpc_id}-elasticsearch-${local.elastic_cluster_name_prefix}"
  description = "Security group for elasticsearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "lg" {
  name = "${var.vpc_id}-elasticsearch-${local.elastic_cluster_name_prefix}-lg"

  tags = var.common_tags
}

data "aws_iam_policy_document" "es_log_publishing_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:GetLogEvents",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = data.aws_iam_policy_document.es_log_publishing_policy_document.json
  policy_name     = "elasticsearch-log-publishing-policy"
}
