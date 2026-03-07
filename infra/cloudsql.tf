############################################
# CLOUD SQL INSTANCE (COST OPTIMIZED)
############################################

resource "google_sql_database_instance" "mysql" {

  name             = "probestack-mysql-prod"
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {

    tier              = var.db_tier
    availability_type = "ZONAL"

    # Cloud SQL only supports PD_SSD or PD_HDD
    disk_type = "PD_SSD"

    disk_autoresize = true

    ip_configuration {

      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id

      enable_private_path_for_google_cloud_services = true

      # Enforce encrypted connections
      ssl_mode = "ENCRYPTED_ONLY"
    }

    backup_configuration {

      enabled            = true
      binary_log_enabled = true
      start_time         = "02:00"

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
  }

  deletion_protection = false

  depends_on = [
    google_service_networking_connection.psa
  ]
}

############################################
# DATABASE
############################################

resource "google_sql_database" "prod_db" {

  name     = "probestack-prod-db"
  instance = google_sql_database_instance.mysql.name

}

############################################
# DATABASE USER
############################################

resource "google_sql_user" "admin" {

  name     = var.db_user
  password = var.db_password
  instance = google_sql_database_instance.mysql.name

}