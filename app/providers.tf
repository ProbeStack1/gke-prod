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

data "terraform_remote_state" "infra" {
  backend = "gcs"

  config = {
    bucket = "probestack-prod-tf-state-prod"
    prefix = "gke-prod/infra"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.infra.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.infra.outputs.cluster_ca
  )
  token = data.google_client_config.default.access_token
}

provider "kubectl" {
  host                   = "https://${data.terraform_remote_state.infra.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.infra.outputs.cluster_ca
  )
  token            = data.google_client_config.default.access_token
  load_config_file = false
}
