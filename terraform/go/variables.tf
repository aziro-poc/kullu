variable "db_host" {
  type        = string
  default     = "localhost"
  description = "Postgres host"
}

variable "db_port" {
  type        = number
  default     = 5432
}

variable "db_username" {
  type        = string
  default     = "admin"
}

variable "db_password" {
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "db_name" {
  type    = string
  default = "configs"
}