variable "aws_account_id" {
  description = "current aws account id"
  type        = string
}
variable "aws_region_name" {
  description = "aws region name where the cluster will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/test/loadtest/staging/preprod/prod)"
  type        = string
}
variable "system" {
  description = "Name of the system or environment where these resources are deployed."
  type        = string
}
variable "project" {
  description = "The internal name of the project to which these resources belong."
  type        = string
}
variable "team" {
  description = "Name of the search."
  type        = string
  default     = "search"
}

variable "common_tags" {
  description = "common tags from root module"
  type        = map(string)
}

variable "elasticsearch_version" {
  description = "Version of the elasticsearch cluster"
  type        = string
}

variable "vpc_id" {
  description = "vpc id in which the cluster will be created"
  type        = string
}
variable "subnet_ids" {
  description = "subnet ids of cluster to be created"
  type        = list(string)
}

variable "cidr_blocks" {
  description = "elastic search ingress cidr blocks"
  type        = list(string)
}

variable "es_service_linked_role" {
  description = "elasticsearch service linked role"
}

variable "elastic_nodes_type" {
  description = "Instance type for the ES nodes"
  type        = string
}
variable "elastic_nodes_count" {
  description = "Number of ES data nodes"
  type        = number
  default     = 1
}
variable "elastic_nodes_az_count" {
  description = "Number of availability zones to spread the nodes on. 2 or 3"
  type        = number
  default     = 1
}
variable "elastic_nodes_ebs_enabled" {
  description = "Whether EBS volumes are attached to data nodes in the domain. It based on the instance type: https://aws.amazon.com/elasticsearch-service/pricing/"
  type        = bool
}
variable "elastic_nodes_ebs_volume_size" {
  description = "The size of EBS volumes attached to data nodes (in GiB)"
  type        = number
}

variable "user_pool_id" {
  description = "user pool id for kibana"
  type        = string
}

variable "identity_pool_id" {
  description = "identity pool id for kibana "
  type        = string
}
variable "cognito_auth_arn" {
  description = "cognito_auth_arn for kibana "
  type        = string
}
