# SSL POLICY

resource "google_compute_ssl_policy" "prod_ssl_policy" {
  name            = "probestack-prod-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"

  lifecycle {
    prevent_destroy = true
  }
}

# WAIT FOR GKE

resource "time_sleep" "wait_for_gke" {
  depends_on = [
    google_container_cluster.zonal,
    google_container_node_pool.zonal_main
  ]

  create_duration = "60s"
}

# PRODUCTION FRONTEND CONFIG

resource "kubernetes_manifest" "prod_frontend_config" {

  depends_on = [
    time_sleep.wait_for_gke,
    kubernetes_namespace.production
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = "prod-frontend-config"
      namespace = kubernetes_namespace.production.metadata[0].name
    }

    spec = {
      sslPolicy = google_compute_ssl_policy.prod_ssl_policy.name
    }
  }
}


resource "kubernetes_manifest" "forgeq_frontend_config" {

  depends_on = [
    time_sleep.wait_for_gke,
    kubernetes_namespace.forgeq
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = "forgeq-frontend-config"
      namespace = kubernetes_namespace.forgeq.metadata[0].name
    }

    spec = {
      sslPolicy = google_compute_ssl_policy.prod_ssl_policy.name
    }
  }
}

resource "kubernetes_manifest" "forgestudio_frontend_config" {

  depends_on = [
    time_sleep.wait_for_gke,
    kubernetes_namespace.forgestudio
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = "forgestudio-frontend-config"
      namespace = kubernetes_namespace.forgestudio.metadata[0].name
    }

    spec = {
      sslPolicy = google_compute_ssl_policy.prod_ssl_policy.name
    }
  }
}

# FORGESHIFT FRONTEND CONFIG

resource "kubernetes_manifest" "forgeshift_frontend_config" {

  depends_on = [
    time_sleep.wait_for_gke,
    kubernetes_namespace.forgeshift
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"

    metadata = {
      name      = "forgeshift-frontend-config"
      namespace = kubernetes_namespace.forgeshift.metadata[0].name
    }

    spec = {
      sslPolicy = google_compute_ssl_policy.prod_ssl_policy.name
    }
  }
}