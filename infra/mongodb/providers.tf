terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.20"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = "probestack-prod-tf-state-prod"
    prefix = "gke-prod/infra"
  }
}