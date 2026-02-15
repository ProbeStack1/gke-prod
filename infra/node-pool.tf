resource "google_container_node_pool" "main" {
  name     = var.node_pool_name
  location = var.region # Production: Regional (spread across zones)
  cluster  = google_container_cluster.primary.name

  autoscaling {
    min_node_count = 1
    max_node_count = 5 
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    service_account = google_service_account.k8s_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    image_type = "COS_CONTAINERD"

    machine_type = "e2-standard-4"

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      environment = "production"
      tier        = "app"
    }
  }
}