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

variable "region" {
  description = "aws region name"
  type        = string
}

variable "common_tags" {
  description = "common tags from root module"
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_ids" {
  description = "EC2 public subnet ids"
  type        = list(string)
}
