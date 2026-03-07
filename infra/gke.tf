resource "google_container_cluster" "zonal" {
  name     = "probestack-zonal-cluster"
  location = "${var.region}-a"

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.gke.id

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  datapath_provider = "ADVANCED_DATAPATH"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.17.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "temporary-access"
    }
  }

  release_channel {
    channel = "STABLE"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  enable_shielded_nodes = true

  remove_default_node_pool = true
  initial_node_count       = 1
}

############################################
# NODE SERVICE ACCOUNT
############################################

resource "google_service_account" "k8s_nodes" {
  account_id   = "k8s-node-sa"
  display_name = "GKE Node Service Account"
}
