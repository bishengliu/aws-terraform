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

resource "aws_s3_bucket" "tf_remote_state" {
  bucket = var.s3_bucket_name
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Project     = var.project
    System      = var.system
    Team        = var.team
    Environment = var.environment
  }
}
#locking

resource "aws_dynamodb_table" "tf_remote_state_locking" {
  hash_key = "LockID"
  name     = var.dynamodb_locking_table_name
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"

  tags = {
    Project     = var.project
    System      = var.system
    Team        = var.team
    Environment = var.environment
  }
}
