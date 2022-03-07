locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Project     = var.project
    System      = var.system
    Team        = var.team
    Environment = var.environment
    IaC         = "terraform"
  }
}
