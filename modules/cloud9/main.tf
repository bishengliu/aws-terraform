resource "aws_cloud9_environment_ec2" "cloud9" {
  name                        = "cloud9-${var.project}-${var.system}-${var.environment}"
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  automatic_stop_time_minutes = 30

  description = "${var.project}-${var.system}-${var.environment}-cloud9"
  tags        = var.common_tags
}

data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.cloud9.id]
  }
}

data "aws_security_group" "cloud9_sg" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.cloud9.id]
  }
}
