output "elasticsearch" {
  value       = aws_elasticsearch_domain.es
  description = "aws_elasticsearch_domain elastic resoruce"
}

output "elasticsearch_endpoint" {
  value       = aws_elasticsearch_domain.es.endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
}

output "kibana_endpoint" {
  value       = aws_elasticsearch_domain.es.kibana_endpoint
  description = "Domain-specific endpoint for kibana without https scheme."
}
