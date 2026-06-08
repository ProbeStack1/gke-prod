terraform {
  backend "gcs" {
    # Store MongoDB state in the same dev bucket, but different folder
    bucket = "probestack-dev-tf-state-dev"
    prefix = "gke-dev/mongodb"
  }
}