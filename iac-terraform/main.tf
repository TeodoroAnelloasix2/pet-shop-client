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

module "eks" {
  source             = "./modules/eks"
  depends_on         = [module.vpc]
  kubernetes_version = var.kubernetes_version
  vpc_cidr           = module.vpc.vpc_cidr          # Get values form vpc's output
  petshop_vpc_id     = module.vpc.vpc_id            # Get values form vpc's output
  private_subnet_id  = module.vpc.private_subnet_id # Get values form vpc's output
  cluster_name       = var.root_cluster_name
  public_access_cidr = [var.public_access_cidr]
  pr_name            = var.project_name
}

module "ecr" {
  source        = "./modules/ecr"
  tag_exclusion = var.ecr_tag_exclusion
}

module "rds_psql" {
  source         = "./modules/rds_psql"
  pr_name        = var.project_name
  private_subnet = module.vpc.private_subnet_id
  subnets        = module.vpc.private_subnet_id
  vpc_id         = module.vpc.vpc_id
  eks_sg_id      = module.eks.cluster_sg
  username       = var.pssql_data.Username
  dbname         = var.pssql_data.Db
  password       = var.pssql_data.Password
}
module "s3" {
  source = "./modules/s3"
}

module "iam" {
  source = "./modules/iam"  
}