output "database_name" {
  value = module.postgres.database_name
}

output "connection_url" {
  value     = "postgres://${var.db_username}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}"
  sensitive = true
}