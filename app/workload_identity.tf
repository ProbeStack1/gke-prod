############################################
# GOOGLE SERVICE ACCOUNT
############################################

resource "google_service_account" "admin_backend_gsa" {
  account_id   = "admin-backend-sa"
  display_name = "Admin Backend CloudSQL Access"
}

############################################
# CLOUD SQL PERMISSION
############################################

resource "google_project_iam_member" "admin_backend_cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"

  member = "serviceAccount:${google_service_account.admin_backend_gsa.email}"
}

############################################
# KUBERNETES SERVICE ACCOUNT
############################################

resource "kubernetes_service_account" "admin_backend_ksa" {
  metadata {
    name      = "admin-backend-ksa"
    namespace = "secure-production-app"

    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.admin_backend_gsa.email
    }
  }
}

############################################
# WORKLOAD IDENTITY BINDING
############################################

resource "google_service_account_iam_member" "admin_backend_workload_identity" {
  service_account_id = google_service_account.admin_backend_gsa.name
  role               = "roles/iam.workloadIdentityUser"

  member = "serviceAccount:${var.project_id}.svc.id.goog[secure-production-app/admin-backend-ksa]"
}