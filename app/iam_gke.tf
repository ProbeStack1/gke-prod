resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = "probestack-prod"
  role    = "roles/artifactregistry.reader"

  member  = "serviceAccount:k8s-node-sa@probestack-prod.iam.gserviceaccount.com"
}
