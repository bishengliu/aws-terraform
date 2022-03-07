output "ec2" {
  value       = aws_instance.ec2
  description = "ec2 resoruce"
}

output "aws_key_pair" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
