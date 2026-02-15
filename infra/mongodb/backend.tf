terraform {
  backend "gcs" {
    # Store MongoDB state in the same production bucket, but different folder
    bucket = "probestack-prod-tf-state-prod"
    prefix = "gke-prod/mongodb"
  }
}