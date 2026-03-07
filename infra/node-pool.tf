resource "google_container_node_pool" "zonal_main" {

  name     = "zonal-main-pool"
  location = "${var.region}-a"
  cluster  = google_container_cluster.zonal.name

  autoscaling {
    min_node_count = 1
    max_node_count = 6
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  version = google_container_cluster.zonal.min_master_version

  node_config {

    service_account = google_service_account.k8s_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    machine_type = "e2-standard-2"

    image_type = "COS_CONTAINERD"

    disk_size_gb = 30
    disk_type    = "pd-standard"

    labels = {
      environment = "production"
      tier        = "app"
      nodepool    = "zonal"
    }

    tags = ["gke-node"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}