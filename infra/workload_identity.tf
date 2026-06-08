# GCP SERVICE ACCOUNT

resource "google_service_account" "app_sa" {
  account_id   = "probestack-app-sa"
  display_name = "Probestack Application Service Account"
  project      = var.project_id
}

# IAM ROLE (STORAGE ACCESS)

resource "google_project_iam_member" "app_sa_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# WORKLOAD IDENTITY BINDINGS (ALL NAMESPACES)

locals {
  wi_namespaces = [
    "probestack-dev",
    "forgeq-dev",
    "forgeshift-dev",
    "forgestudio-dev",
    "forgesphere-dev",
    "forgeai-dev",
    "forgekonnect-dev",
    "forgehub-dev"
  ]
}

resource "google_service_account_iam_member" "workload_identity_binding" {

  for_each = toset(local.wi_namespaces)

  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.workloadIdentityUser"

  member = "serviceAccount:${var.project_id}.svc.id.goog[${each.value}/default]"
}

# ANNOTATE DEFAULT SERVICE ACCOUNT (ALL NS)

resource "kubernetes_annotations" "default_sa_annotation" {

  for_each = toset(local.wi_namespaces)

  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "default"
    namespace = each.value
  }

  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.app_sa.email
  }

  depends_on = [
    kubernetes_namespace.dev,
    kubernetes_namespace.forgeq,
    kubernetes_namespace.forgeshift,
    kubernetes_namespace.forgestudio,
    kubernetes_namespace.forgesphere,
    kubernetes_namespace.forgeai,
    kubernetes_namespace.forgehub,
    kubernetes_namespace.forgekonnect
  ]
}