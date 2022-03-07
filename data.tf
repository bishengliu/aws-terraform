data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/terraform/vpc_id"
}
data "aws_vpc" "selected" {
  id = data.aws_ssm_parameter.vpc_id.value
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    "myCompany.io/v1/private-network" = 1
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.selected.id

  # use tags to filter the public subnets 
  tags = {
    "myCompany.io/v1/public-network" = 1
  }
}

data "aws_subnet_ids" "alt_public_subnets" {
  vpc_id = data.aws_vpc.selected.id

  # use tags to filter the public subnets 
  tags = {
    "kubernetes.io/role/elb" = 1
  }
}

data "aws_ssm_parameter" "my_office_cidrs" {
  name = "/terraform/network/my_office_cidrs"
}

data "aws_ssm_parameter" "internal_monitoring_cidrs" {
  name = "/terraform/network/internal_monitoring_cidrs"
}

data "aws_ssm_parameter" "es_service_linked_role" {
  name = "/terraform/iam/roles/ElasticSearchServiceLinkedRole"
}

