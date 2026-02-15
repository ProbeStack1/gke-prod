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
}