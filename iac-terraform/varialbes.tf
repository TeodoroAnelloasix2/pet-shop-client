variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "root_cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "pet-shop-cluster"
}


variable "kubernetes_version" {
  description = "Kubectl version"
  type        = string
  default     = "1.34"
}

variable "petshop_vpc_id" {
  description = "VPC id"
  type        = string
}

variable "private_subnets_id" {
  description = "List of private subnets ids"
  type        = list(string)
}


variable "pubblic_access_cidr" {
  description = "IP white list: curl -s ifconfig.me"
  type        = list(string)
}

variable "ecr_tag_exclusion" {
  description = "List of image tags excluded from immutability"
  type        = list(string)
  default     = ["latest*", "dev*"]
}