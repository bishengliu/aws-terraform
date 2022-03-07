
output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9.id}"
}

output "cloud9" {
  value       = aws_cloud9_environment_ec2.cloud9
  description = "aws_cloud9_environment_ec2 cloud9 resoruce"
}

output "cloud9_sg_id" {
  value = data.aws_security_group.cloud9_sg.id
}
