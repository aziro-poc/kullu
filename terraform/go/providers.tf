terraform {
  required_version = ">= 1.3.0"

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}
provider "postgresql" {
  host     = var.db_host
  port     = var.db_port
  username = var.db_username
  password = var.db_password
  sslmode  = "disable"
}