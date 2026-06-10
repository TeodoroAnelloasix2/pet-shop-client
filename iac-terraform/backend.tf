#https://terrateam.io/blog/terraform-state-aws-s3-backend
terraform {
  backend "s3" {
    bucket         = "tfstate-remote-bkt-petshop"
    region         = "us-east-1"
    key            = "petshop-prod/terraform.tfstate"
    dynamodb_table = "is-tfstate-locked"
    encrypt        = true
  }
}