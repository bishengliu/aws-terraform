terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.69"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# elasticsearch
module "elasticsearch" {
  source = "./modules/elasticsearch"
  # pass variables
  aws_account_id  = data.aws_caller_identity.current.account_id
  aws_region_name = data.aws_region.current.name

  project     = var.project
  system      = var.system
  environment = var.environment
  team        = var.team

  vpc_id     = data.aws_vpc.selected.id
  subnet_ids = data.aws_subnet_ids.private_subnets.ids
  cidr_blocks = concat(
    [data.aws_vpc.selected.cidr_block],
    split(",", data.aws_ssm_parameter.my_office_cidrs.value),
    split(",", data.aws_ssm_parameter.internal_monitoring_cidrs.value),
  )

  es_service_linked_role        = data.aws_ssm_parameter.es_service_linked_role
  elastic_nodes_type            = "t3.small.elasticsearch"
  elastic_nodes_count           = 1
  elastic_nodes_az_count        = 1
  elastic_nodes_ebs_volume_size = 10
  elastic_nodes_ebs_enabled     = true
  elasticsearch_version         = "7.9"

  # cognito
  user_pool_id     = module.cognito.user_pool_id
  identity_pool_id = module.cognito.identity_pool_id
  cognito_auth_arn = module.cognito.cognito_auth_arn

  common_tags = local.common_tags
}

# cognito
module "cognito" {
  source = "./modules/cognito"

  project     = var.project
  system      = var.system
  environment = var.environment
  team        = var.team

  region         = data.aws_region.current.name
  cognito_domain = "${var.project}-${var.system}-${var.environment}"

  master_username = "username@example.com"

  common_tags = local.common_tags
}

# ec2
module "ec2" {
  source          = "./modules/ec2"
  aws_region_name = data.aws_region.current.name

  project     = var.project
  system      = var.system
  environment = var.environment

  vpc_id              = data.aws_vpc.selected.id
  private_subnet_ids  = tolist(data.aws_subnet_ids.private_subnets.ids)
  ingress_cidr_blocks = ["10.0.0.0/8"]

  ec2_volume_size = 10
  ec2_key_name    = "${var.project}-${var.system}-${var.environment}-ec2-key"
  instance_type   = "t2.micro"

  common_tags = local.common_tags
}

# cloud9

module "cloud9" {
  source      = "./modules/cloud9"
  count       = var.create_cloud9 ? 1 : 0
  region      = data.aws_region.current.name
  project     = var.project
  system      = var.system
  environment = var.environment

  public_subnet_ids = data.aws_subnet_ids.alt_public_subnets.ids
  instance_type     = "t2.micro"
  common_tags       = local.common_tags
}

# docdb
module "docdb" {
  source = "./modules/documentdb"

  project     = var.project
  system      = var.system
  environment = var.environment

  vpc_id             = data.aws_vpc.selected.id
  private_subnet_ids = data.aws_subnet_ids.private_subnets.ids

  cidr_blocks = concat(
    ["172.28.0.0/16"],
    [data.aws_vpc.selected.cidr_block],
    split(",", data.aws_ssm_parameter.my_office_cidrs.value),
    split(",", data.aws_ssm_parameter.internal_monitoring_cidrs.value),
  )

  docdb_instance_class = "db.r5.2xlarge"

  create_cloud9 = var.create_cloud9
  cloud9_sg_id  = var.create_cloud9 ? module.cloud9[0].cloud9_sg_id : ""

  common_tags = local.common_tags
}
