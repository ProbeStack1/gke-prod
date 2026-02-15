terraform {
  backend "gcs" {
    # Store the APP state in the same bucket, but a different folder (prefix)
    bucket = "probestack-prod-tf-state-prod"
    prefix = "gke-prod/apps/react-vite" 
  }
}