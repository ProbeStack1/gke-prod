resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com"
  ])

  service = each.value
  disable_on_destroy = true
}