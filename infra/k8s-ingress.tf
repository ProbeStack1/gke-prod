############################################
# STATIC GLOBAL IP
############################################

resource "google_compute_global_address" "ingress_ip" {
  name        = "probestack-prod-ingress-ip"
  description = "Static IP for Production Ingress"

  lifecycle {
    prevent_destroy = true
  }
}

############################################
# GOOGLE MANAGED CERTIFICATE
############################################

resource "kubernetes_manifest" "prod_cert" {

  depends_on = [
    kubernetes_namespace.production
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "probestack-prod-cert"
      namespace = "secure-production-app"
    }

    spec = {
      domains = [
        var.domain_name
      ]
    }
  }
}

############################################
# PRODUCTION INGRESS
############################################

resource "kubernetes_ingress_v1" "prod_ingress" {

  depends_on = [
    kubernetes_manifest.prod_cert,
    kubernetes_manifest.prod_frontend_config,
    google_compute_global_address.ingress_ip
  ]

  metadata {
    name      = "prod-ingress"
    namespace = "secure-production-app"

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_ip.name
      "networking.gke.io/managed-certificates"      = "probestack-prod-cert"
      "networking.gke.io/frontend-config"           = "prod-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {

    rule {
      host = var.domain_name

      http {

        path {
          path      = "/admin"
          path_type = "Prefix"

          backend {
            service {
              name = "react-admin"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/admin-backend"
          path_type = "Prefix"

          backend {
            service {
              name = "admin-backend"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "apigee-edge-mock-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/config/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-profile-config-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/discovery/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-apigee-discovery-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/assessment/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-apigee-assessment-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/migration/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-apigee-migration-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/deployments/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-apigee-deployment-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/cutover/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "apigee-cutover"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "react-vite"
              port { number = 80 }
            }
          }
        }

      }
    }

    default_backend {
      service {
        name = "react-vite"

        port {
          number = 80
        }
      }
    }

  }
}