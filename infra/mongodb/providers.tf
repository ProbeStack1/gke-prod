terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.20"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# MongoDB Atlas (unchanged)
provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = "probestack-dev-tf-state"
    prefix = "gke-dev/infra"
  }
}

# Needed for auth token
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = data.terraform_remote_state.infra.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.cluster_ca)
  token                  = data.google_client_config.default.access_token
}