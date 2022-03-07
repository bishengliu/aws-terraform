terraform {
  backend "s3" {
    bucket = "my-s3-bucket"
    key    = "my-project/terraform.tfstate"
    region = "eu-west-1"
  }
}
