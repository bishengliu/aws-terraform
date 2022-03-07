# AWS IaC using terraform

- backend: terraform S3 backend plus locking using dynamodb; please read [doc](/backend/README.md)
- terraform modules: contains all the terraform modules; please don't put resources in the root module.

## Why

- spin up a new infra for infra development or any testing
- todo: create a separated infra for each MR via pipelines by dynamic generating a `backend.tf` file, which using different S3 keys

## How

- create a file called `backend.tf` and ask your team members for the content of this file if you don't need to start from scratch

- if you want to start an infra from scratch, copy the the following into `backend.tf`

```
terraform {
  backend "s3" {
    bucket = "my-s3-bucket" # the backend s3 bucket, Please read [doc](/backend/README.md)
    key    = "my_unique_terraform.tfstate" # my **unique** S3 bucket key. Please make sure it is unique!!!
    region = "eu-west-1"
  }
}

```

what could happen if the above s3 bucket key is not unique? You might destory existing aws resoruces!!!

- create a file called `terraform.tfvars` and paste the following

```
project     = "yeti"
system      = "search"
team        = "search"
environment = "mr-xxx"
```

- strongly recommend checking-in the `.terraform.lock.hcl`; read [here](https://www.terraform.io/language/files/dependency-lock) for more about the lock file.

- `terraform init && terraform plan`
