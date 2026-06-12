variable "cluster_name" {
  description = "Project cluster name"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubectl version"
  type        = string
  default     = "latest"
}
variable "petshop_vpc_id" {
  description = "VPC id"
  type        = string
}

variable "private_subnets_id" {
  description = "CIDR blocks for private subnet"
  type        = list(string)
}

variable "pubblic_access_cidr" {
  description = "List of allowed ip"
  type        = list(string)
}