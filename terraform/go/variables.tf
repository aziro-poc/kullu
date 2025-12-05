variable "db_host" {
  type        = string
  description = "Postgres host"
}

variable "db_port" {
  type        = number
  default     = 5432
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "db_name" {
  type    = string
  default = "configs"
}