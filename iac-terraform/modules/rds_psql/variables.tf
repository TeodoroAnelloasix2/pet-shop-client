variable "pr_name" {
  description = "Project name"
  type        = string
}

variable "bd_engine" {
  description = "Engine sql"
  type        = string
  default     = "postgres"
}


variable "bd_version" {
  description = "Engine sql"
  type        = string
  default     = "17.10"
}

variable "db_family" {
  type    = string
  default = "postgres17"
}

variable "instances_class" {
  type    = string
  default = "db.t3.micro"
}

variable "private_subnet" {
  description = "Private subntes ids"
  type        = list(string)
}

variable "storage_size" {
  description = "Min and Max storage allocate"
  type        = list(number)
  default     = ["10", "50"]
}

variable "subnets" {
  description = "Subnets name"
  type        = list(string)
}

variable "vpc_id" {
  description = "Main vpc id"
  type        = string
}

variable "eks_sg_id" {
  description = "Security group of eks nodes"
  type        = string
}


variable "username" {
  type = string
}
variable "dbname" {
  type = string
}
variable "password" {
  type = string
}