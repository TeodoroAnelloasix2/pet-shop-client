variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "cluster-name" {
  description = "Cluster name"
  type        = string
  default     = "pet-shop-cluster"
}


variable "kubernetes_version" {
  description = "Kubectl version"
  type        = string
  default     = "1.35.5"
}

variable "petshp-vpc_id" {
  description = "VPC id"
  type        = string
  default     = "vpc-00fae73877934ba67"
}