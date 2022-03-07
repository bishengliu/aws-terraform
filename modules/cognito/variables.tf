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

variable "region" {
  description = "aws region name"
  type        = string
}

variable "cognito_domain" {
  description = "domain name of the user pool."
  type        = string
}

variable "common_tags" {
  description = "common tags from root module"
  type        = map(string)
}

variable "master_username" {
  description = "email as the username to sign in kibana"
  type        = string
}

