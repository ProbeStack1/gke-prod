resource "google_sql_database_instance" "mysql" {
  name             = var.db_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled    = false # Disable Public IP
      private_network = google_compute_network.vpc.id # Updated to use the variable-based network resource
      enable_private_path_for_google_cloud_services = true
      
      require_ssl = true
    }

    availability_type = "REGIONAL"

    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true # Enabling binary logs enables PITR for MySQL automatically
      start_time                     = "02:00" # UTC
      
      transaction_log_retention_days = 7 

      backup_retention_settings {
        retained_backups = 14
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day  = 7 # Sunday
      hour = 3 # 3 AM
    }
    
    disk_autoresize = true
  }

  deletion_protection = true

  depends_on = [google_service_networking_connection.psa]
}

resource "google_sql_database" "prod_db" {
  name     = "probestack-prod-db"
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "admin" {
  name     = var.db_user
  password = var.db_password
  instance = google_sql_database_instance.mysql.name
}