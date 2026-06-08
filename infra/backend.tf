terraform {
  backend "gcs" {
    bucket = "probestack-dev-tf-state"
    prefix = "gke-dev/infra"
  }
}