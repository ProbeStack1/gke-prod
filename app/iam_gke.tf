resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = "methodical-mark-482504-j3"
  role    = "roles/artifactregistry.reader"

  member = "serviceAccount:k8s-node-sa@methodical-mark-482504-j3.iam.gserviceaccount.com"
}
