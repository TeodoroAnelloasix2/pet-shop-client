terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.48.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "prod"
      Manteiner   = "TeodoroAnelloasix2"
      ProjectName = "pet-shop"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
  azs    = var.azs
}