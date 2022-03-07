resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = "${var.project}-${var.system}-${var.environment}-docdb-cluster"
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.parameter_group.name
  db_subnet_group_name            = aws_docdb_subnet_group.subnet_group.name
  engine                          = "docdb"
  master_password                 = random_password.master_password.result
  master_username                 = local.master_username
  skip_final_snapshot             = true
  storage_encrypted               = true
  vpc_security_group_ids          = [aws_security_group.docdb_sg.id]

  tags = var.common_tags
}

resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  family = "docdb4.0"
  name   = "${var.project}-${var.system}-${var.environment}-docdb-parameter-group"

  tags = var.common_tags
}

resource "aws_docdb_subnet_group" "subnet_group" {
  name       = "${var.project}-${var.system}-${var.environment}-docdb-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.common_tags
}

resource "aws_security_group" "docdb_sg" {
  name        = "${var.project}-${var.system}-${var.environment}-docdb-sg"
  description = "Security group for mongo client access to documentdb"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  # 
  dynamic "ingress" {
    for_each = var.create_cloud9 ? [var.cloud9_sg_id] : []
    content {
      from_port = 27017
      to_port   = 27017
      protocol  = "tcp"

      security_groups = [ingress.value]
    }
  }

  tags = var.common_tags
}

resource "aws_docdb_cluster_instance" "db_instance" {
  cluster_identifier = aws_docdb_cluster.docdb.id
  count              = 1
  identifier         = "${var.project}-${var.system}-${var.environment}-docdb-instance${count.index}"
  instance_class     = var.docdb_instance_class

  tags = var.common_tags
}
