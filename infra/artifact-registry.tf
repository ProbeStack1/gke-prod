resource "google_artifact_registry_repository" "repo" {

  depends_on = [
    google_project_service.services["artifactregistry.googleapis.com"]
  ]

  location      = var.region
  repository_id = var.artifact_repo_name
  description   = "Docker repository for production images"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }

  ############################################
  # DELETE OLD IMAGES
  ############################################

  cleanup_policies {

    id     = "delete-old-images"
    action = "DELETE"

    condition {
      tag_state  = "ANY"
      older_than = "1209600s"
    }
  }

  ############################################
  # DELETE UNTAGGED IMAGES
  ############################################

  cleanup_policies {

    id     = "delete-untagged"
    action = "DELETE"

    condition {
      tag_state  = "UNTAGGED"
      older_than = "259200s"
    }
  }

  ############################################
  # KEEP MOST RECENT IMAGES
  ############################################

  cleanup_policies {

    id     = "keep-recent"
    action = "KEEP"

    most_recent_versions {
      keep_count = 10
    }
  }
}