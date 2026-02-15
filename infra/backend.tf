terraform {
  backend "gcs" {
    bucket = "probestack-prod-tf-state-prod"
    prefix = "gke-prod/infra"
  }
}