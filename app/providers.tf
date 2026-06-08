terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

# -----------------------------
# Google provider
# -----------------------------
provider "google" {
  project = var.project_id
  region  = var.region
}

# -----------------------------
# Auth token
# -----------------------------
data "google_client_config" "default" {}

# -----------------------------
# Fetch GKE cluster directly (NO remote state)
# -----------------------------
data "google_container_cluster" "gke" {
  name     = "probestack-dev-cluster"
  location = "us-central1-a"
  project  = var.project_id
}

# -----------------------------
# Kubernetes provider
# -----------------------------
provider "kubernetes" {
  host = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
}

# -----------------------------
# Kubectl provider
# -----------------------------
provider "kubectl" {
  host = "https://${data.google_container_cluster.gke.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  )
  token            = data.google_client_config.default.access_token
  load_config_file = false
}