data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"                         # fiter on image name
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # amazon ami image name
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_ebs_volume" "ec2_volume" {
  availability_zone = "${var.aws_region_name}a"
  size              = var.ec2_volume_size

  tags = var.common_tags
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = var.common_tags
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.latest_amazon_linux_image.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone      = "${var.aws_region_name}a"

  associate_public_ip_address = false
  key_name                    = aws_key_pair.generated_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_access_es_profile.name

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.system}-${var.environment}-ec2"
  })
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ec2_volume.id
  instance_id = aws_instance.ec2.id
}

resource "aws_security_group" "ec2_sg" {
  name   = "${var.project}-${var.system}-${var.environment}-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = var.common_tags
}

resource "aws_iam_instance_profile" "ec2_access_es_profile" {
  name = "${var.project}-${var.system}-${var.environment}-ec2-access-es-profile"
  role = aws_iam_role.ec2_access_es_role.name

  tags = var.common_tags
}
