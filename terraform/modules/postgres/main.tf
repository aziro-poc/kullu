terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
}

resource "postgresql_database" "configs_db" {
  name = var.db_name
}

# Run SQL script to create table
resource "null_resource" "configs_table" {
  depends_on = [postgresql_database.configs_db]

  provisioner "local-exec" {
    command = <<EOT
psql "postgresql://${var.db_username}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}" <<SQL
CREATE TABLE IF NOT EXISTS configs (
    id SERIAL PRIMARY KEY,
    host TEXT,
    port INT,
    app_name TEXT,
    log_level TEXT
);
SQL
EOT
  }
}
