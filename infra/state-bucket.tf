resource "google_storage_bucket" "tf_state" {
  name          = "probestack-prod-tf-state-prod" 
  location      = "US"
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}