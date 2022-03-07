# A one-time set up the backend

This folder helps to setup the new terraform aws S3 backend. It creates a s3 bucket to store the tf state files and a dynamodb table for locking.

You don't normally need to do this and the chance is that your colleagues have done this for you already. If you want to setup the infra from scratch, you can choose a different s3 key using the same backend and locking table. Please choose [a unique backend s3 key](/README.md).

# How to start

**Stop here if don't know what you are doing!** :-)

- create a file called `terraform.tfstate` in the root of this folder and put this file into your `.gitignore` file
- add the following variables into `terraform.tfstate`

```

project                     = "myprojct"
system                      = "mysystem"
team                        = "myteam"
environment                 = "myenvironment"
s3_bucket_name              = "my_unique_s3_bucket_namw"
dynamodb_locking_table_name = "my_unique_dynamodb_table_name"

```

- `terraform init && terraform plan`
