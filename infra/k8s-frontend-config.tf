############################################
# PRODUCTION SSL POLICY
############################################

resource "google_compute_ssl_policy" "prod_ssl_policy" {
  name            = "probestack-prod-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"

  lifecycle {
    prevent_destroy = true
  }
}

############################################
# GKE FRONTEND CONFIG
############################################

resource "kubernetes_manifest" "prod_frontend_config" {

  depends_on = [
    google_container_cluster.zonal,
    google_container_node_pool.zonal_main,
    kubernetes_namespace.production
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = "prod-frontend-config"
      namespace = "secure-production-app"
    }

    spec = {
      redirectToHttps = {
        enabled = true
      }

      sslPolicy = google_compute_ssl_policy.prod_ssl_policy.name
    }
  }
}