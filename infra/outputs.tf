output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.zonal.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = google_container_cluster.zonal.endpoint
  sensitive   = true
}

output "cluster_ca" {
  description = "The public certificate authority of the cluster"
  value       = google_container_cluster.zonal.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the cluster"
  value       = google_container_cluster.zonal.location
}

output "sql_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.mysql.connection_name
}