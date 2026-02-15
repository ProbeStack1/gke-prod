resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
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
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0" # TODO: REPLACE with your VPN/Office IP
      display_name = "Allow-All-Warning"
    }
  }

  release_channel {
    channel = "STABLE"
  }

  deletion_protection      = true # Prevents accidental terraform destroy
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_service_account" "k8s_nodes" {
  account_id   = "k8s-node-sa"
  display_name = "GKE Node Service Account"
}