resource "google_service_account" "app_sa" {
  account_id   = "probestack-app-sa"
  display_name = "Probestack Application Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "app_sa_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin" # Read/Write access to objects
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[secure-production-app/default]"
}

resource "kubernetes_annotations" "default_sa_annotation" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = "default"
    namespace = "secure-production-app"
  }
  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.app_sa.email
  }
  
  depends_on = [
    kubernetes_namespace.production
  ]
}