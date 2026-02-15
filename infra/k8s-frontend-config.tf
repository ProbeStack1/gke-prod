resource "google_compute_ssl_policy" "prod_ssl_policy" {
  name            = "probestack-prod-ssl-policy"
  profile         = "MODERN"   
  min_tls_version = "TLS_1_2" 
}

resource "kubernetes_manifest" "prod_frontend_config" {
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