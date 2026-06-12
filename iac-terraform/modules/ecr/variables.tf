variable "ecr_name" {
  description = "Repository name"
  type        = string
  default     = "prod_petshop_project"
}
variable "image_mutability" {
  description = "Image tag mutability"
  type        = string
  default     = "IMMUTABLE_WITH_EXCLUSION"
}

variable "tag_exclusion" {
  description = "Exclude dev/latest tags from immutability"
  type        = list(string)
}

variable "encrypt_type" {
  description = "Encryption algorithm"
  type        = string
  default     = "KMS"
}