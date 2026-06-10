variable "vpc_cidr" {
  description = "CIDR Block vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "pet-shop"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnet"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# At least two az needed for eks cluster
variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}