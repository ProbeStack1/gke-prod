resource "google_storage_bucket" "tf_state" {
  name     = "probestack-dev-tf-state"
  location = "US-CENTRAL1"

  force_destroy = false

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  # Automatically clean up old state versions
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}