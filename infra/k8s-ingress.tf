resource "google_compute_global_address" "ingress_ip" {
  name        = "probestack-prod-ingress-ip"
  description = "Static IP for Production Ingress"
}

resource "kubernetes_manifest" "prod_cert" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"
    metadata = {
      name      = "probestack-prod-cert"
      namespace = "secure-production-app"
    }
    spec = {
      domains = [var.domain_name]
    }
  }
}

resource "kubernetes_ingress_v1" "prod_ingress" {
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
    default_backend {
      service {
        name = "react-vite"
        port { number = 80 }
      }
    }

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
          path      = "/probestack/v1/apigee/edge"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-profile-config-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/x"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-profile-config-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/cloud-storage/config"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-profile-config-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/assetinfo"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-discovery-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/discovery"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-discovery-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/assessment"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-assessment-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/migration"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-migration-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/deployments"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-deployment-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/proxies/validate"
          path_type = "Prefix"
          backend {
            service {
              name = "probestack-apigee-deployment-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/probestack/v1/apigee/cutover"
          path_type = "Prefix"
          backend {
            service {
              name = "apigee-cutover"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "react-vite"
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}
