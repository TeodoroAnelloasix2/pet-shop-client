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
  default     = "18.4"
}

variable "db_family" {
  type    = string
  default = "postgres18"
}

variable "instances_class" {
  type    = string
  default = "t3.small"
}

variable "private_subnet" {
  description = "Private subntes ids" 
  type = list(string)
}