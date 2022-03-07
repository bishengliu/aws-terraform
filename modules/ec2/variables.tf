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

variable "aws_region_name" {
  description = "aws region name"
  type        = string
}

variable "vpc_id" {
  description = "vpc id in which the cluster will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "EC2 private subnet ids"
  type        = list(string)
}

variable "ingress_cidr_blocks" {
  description = "ingress cidr blocks"
  type        = list(string)
}

variable "ec2_volume_size" {
  description = "ec2 mounted volumne size in GB"
  type        = number
  default     = 10
}

variable "common_tags" {
  description = "common tags from root module"
  type        = map(string)
}

variable "ec2_key_name" {
  description = "EC2 key name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
