variable "project" {
  description = "The internal name of the project to which these resources belong."
  type        = string
  default     = "myproject"
}
variable "environment" {
  description = "Environment name (dev/test/loadtest/staging/preprod/prod)"
  type        = string
  default     = "myenv"
}
variable "system" {
  description = "Name of the system or environment where these resources are deployed."
  type        = string
  default     = "mysystem"
}
variable "team" {
  description = "Name of the search."
  type        = string
  default     = "myteam"
}

variable "create_cloud9" {
  description = "a boolean indicating whether a cloud9 should be created"
  type        = bool
  default     = false
}
