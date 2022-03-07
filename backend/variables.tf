variable "project" {
  description = "The internal name of the project to which these resources belong."
  type        = string
  default     = "yeti"
}
variable "environment" {
  description = "Environment name (dev/test/loadtest/staging/preprod/prod)"
  type        = string
  default     = "ephemeral"
}
variable "system" {
  description = "Name of the system or environment where these resources are deployed."
  type        = string
  default     = "search"
}
variable "team" {
  description = "Name of the search."
  type        = string
  default     = "search"
}
variable "s3_bucket_name" {
  description = "Name of the backend s3 bucket."
  type        = string
}
variable "dynamodb_locking_table_name" {
  description = "Name of the dynamodb locking table"
  type        = string
}
