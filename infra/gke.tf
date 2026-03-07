############################################
# GKE CLUSTER
############################################

resource "google_container_cluster" "zonal" {
  name     = "probestack-zonal-cluster"
  location = "${var.region}-a"

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.gke.id

  networking_mode = "VPC_NATIVE"

  ############################################
  # MAINTENANCE WINDOW
  ############################################

  maintenance_policy {
    recurring_window {
      start_time = "2026-01-01T02:00:00Z"
      end_time   = "2026-01-01T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SU"
    }
  }

  ############################################
  # NETWORKING
  ############################################

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  datapath_provider = "ADVANCED_DATAPATH"

  ############################################
  # PRIVATE CLUSTER
  ############################################

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.17.0.0/28"
  }

  ############################################
  # WORKLOAD IDENTITY
  ############################################

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ############################################
  # MASTER ACCESS
  ############################################

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "temporary-access"
    }
  }

  ############################################
  # RELEASE CHANNEL
  ############################################

  release_channel {
    channel = "STABLE"
  }

  ############################################
  # OBSERVABILITY
  ############################################

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  ############################################
  # SECURITY
  ############################################

  enable_shielded_nodes = true

  ############################################
  # REMOVE DEFAULT NODE POOL
  ############################################

  remove_default_node_pool = true
  initial_node_count       = 1
}

############################################
# NODE SERVICE ACCOUNT
############################################

resource "google_service_account" "k8s_nodes" {
  account_id   = "k8s-node-sa"
  display_name = "GKE Node Service Account"
  project      = var.project_id
}

############################################
# IAM ROLE FOR NODE SERVICE ACCOUNT
############################################

resource "google_project_iam_member" "k8s_nodes_default_role" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.k8s_nodes.email}"
}

############################################
# OPTIONAL (RECOMMENDED) EXTRA PERMISSIONS
############################################

resource "google_project_iam_member" "k8s_nodes_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.k8s_nodes.email}"
}

resource "google_project_iam_member" "k8s_nodes_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.k8s_nodes.email}"
}