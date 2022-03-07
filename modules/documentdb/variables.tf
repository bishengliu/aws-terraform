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

variable "private_subnet_ids" {
  description = "docdb private  subnet ids"
  type        = list(string)
}

variable "docdb_instance_class" {
  default = "db.r5.2xlarge"
}

variable "vpc_id" {
  description = "vpc id in which the cluster will be created"
  type        = string
}

variable "cidr_blocks" {
  description = "docdb ingress cidr blocks"
  type        = list(string)
}

variable "create_cloud9" {
  description = "a boolean indicating whether a cloud9 should be created"
  type        = bool
  default     = false
}

variable "cloud9_sg_id" {
  description = "cloud9 security group id"
  type        = string
}
