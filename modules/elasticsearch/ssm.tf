# Storing ES/Kibana URLs in SSM ParameterStore
resource "aws_ssm_parameter" "ssm-es-endpoint" {
  name  = "/${var.project}/${var.system}/${var.environment}/latest/elasticsearch_endpoint"
  type  = "String"
  value = aws_elasticsearch_domain.es.endpoint
  tags  = var.common_tags
}

resource "aws_ssm_parameter" "ssm-kibana-endpoint" {
  name  = "/${var.project}/${var.system}/${var.environment}/latest/kibana_endpoint"
  type  = "String"
  value = aws_elasticsearch_domain.es.kibana_endpoint
  tags  = var.common_tags
}
