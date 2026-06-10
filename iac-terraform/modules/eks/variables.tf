variable "cluster-name" {
  description = "Project cluster name"
  type        = string
}
variable "kubernetes_version" {
  description = "Kubectl version"
  type        = string
  default     = "latest"
}
variable "petshp-vpc_id" {
  description = "VPC id"
  type        = string
}