module "postgres" {
  source      = "../modules/postgres"
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_host     = var.db_host
  db_port     = var.db_port

  providers = {
    postgresql = postgresql
  }
}
