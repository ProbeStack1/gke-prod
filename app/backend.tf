terraform {
  backend "gcs" {
    # Store the APP state in the same bucket, but a different folder (prefix)
    bucket = "probestack-dev-tf-state"
    prefix = "gke-dev/apps/react-vite"
  }
}