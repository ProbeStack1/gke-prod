output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true # Mark as sensitive to hide in logs
}

output "cluster_ca" {
  description = "The public certificate authority of the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The region of the cluster"
  value       = google_container_cluster.primary.location
}

output "gke_nat_ip" {
  description = "Static Cloud NAT egress IP for GKE (whitelist this IP)"
  value       = google_compute_address.nat_ip.address
}

output "sql_connection_name" {
  description = "The connection name of the Cloud SQL instance to be used in connection strings"
  value       = google_sql_database_instance.mysql.connection_name
}