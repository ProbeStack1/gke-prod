resource "google_compute_global_address" "prod_ip" {
  name        = "probestack-prod-ingress-ip"
  description = "Static IP for Production Ingress"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "prod_cert" {
  depends_on = [
    kubernetes_namespace.production,
    time_sleep.wait_for_gke
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "probestack-prod-cert"
      namespace = kubernetes_namespace.production.metadata[0].name
    }

    spec = {
      domains = [var.domain_name]
    }
  }
}

resource "kubernetes_ingress_v1" "prod_ingress" {

  depends_on = [
    kubernetes_manifest.prod_cert,
    kubernetes_manifest.prod_frontend_config,
    google_compute_global_address.prod_ip
  ]

  metadata {
    name      = "prod-ingress"
    namespace = kubernetes_namespace.production.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.prod_ip.name
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
          path      = "/api-code-generator"
          path_type = "Prefix"

          backend {
            service {
              name = "api-code-generator-ui"
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
        port { number = 80 }
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_compute_global_address" "forgeq_ip" {
  name = "forgeq-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgeq_cert_v2" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgeq-cert-v2"
      namespace = "forgeq-prod"
    }

    spec = {
      domains = ["prod.forgeq.probestack.io"]  # ✅ MUST match
    }
  }
}

resource "kubernetes_ingress_v1" "forgeq_ingress" {

  depends_on = [
    kubernetes_manifest.forgeq_cert_v2,
    kubernetes_manifest.forgeq_frontend_config,
    google_compute_global_address.forgeq_ip
  ]

  metadata {
    name      = "forgeq-ingress"
    namespace = kubernetes_namespace.forgeq.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgeq_ip.name
      "networking.gke.io/managed-certificates"      = "forgeq-cert-v2"
      "networking.gke.io/frontend-config"           = "forgeq-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = var.forgeq_domain

      http {

        path {
          path      = "/api/v1/users"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-user-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/requests"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-request-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/collections"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-collection-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/workspaces"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-workspace-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/monitor"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-monitor-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/mocks"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-mock-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/webhooks"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-webhooks-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/environments"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-environment-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/activity"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-activity-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/document"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-documentation-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/collabration"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-collaboration-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/support"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-support-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/settings"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-setting-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/testfiles"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-testfile-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/testspecs"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-testspec-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/dashboard"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-dashboard-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "forgeq-fe"
              port { number = 80 }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "forgeq-fe"
        port { number = 80 }
      }
    }
  }
}

resource "google_compute_global_address" "forgestudio_ip" {
  name = "forgestudio-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgestudio_cert_v2" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgestudio-cert-v2"
      namespace = "forgestudio-prod"
    }

    spec = {
      domains = ["prod.forgestudio.probestack.io"] 
    }
  }
}

resource "kubernetes_ingress_v1" "forgestudio_ingress" {

  depends_on = [
    kubernetes_manifest.forgestudio_cert_v2,
    kubernetes_manifest.forgestudio_frontend_config,
    google_compute_global_address.forgestudio_ip
  ]

  metadata {
    name      = "forgestudio-ingress"
    namespace = kubernetes_namespace.forgestudio.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgestudio_ip.name
      "networking.gke.io/managed-certificates"      = "forgestudio-cert-v2"
      "networking.gke.io/frontend-config"           = "forgestudio-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = var.forgestudio_domain

      http {


        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "forgestudio-fe"
              port { number = 80 }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "forgestudio-fe"
        port { number = 80 }
      }
    }
  }
}

resource "google_compute_global_address" "forgeshift_ip" {
  name = "forgeshift-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgeshift_cert" {
  depends_on = [
    kubernetes_namespace.forgeshift,
    time_sleep.wait_for_gke
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgeshift-cert"
      namespace = kubernetes_namespace.forgeshift.metadata[0].name
    }

    spec = {
      domains = [var.forgeshift_domain]
    }
  }
}

resource "kubernetes_ingress_v1" "forgeshift_ingress" {
  depends_on = [
    kubernetes_manifest.forgeshift_cert,
    kubernetes_manifest.forgeshift_frontend_config,
    google_compute_global_address.forgeshift_ip
  ]

  metadata {
    name      = "forgeshift-ingress"
    namespace = kubernetes_namespace.forgeshift.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgeshift_ip.name
      "networking.gke.io/managed-certificates"      = "forgeshift-cert"
      "networking.gke.io/frontend-config"           = "forgeshift-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "false"
    }
  }

  spec {
    rule {
      host = var.forgeshift_domain

      http {
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
        port { number = 80 }
      }
    }
  }
}

resource "google_compute_global_address" "forgeai_ip" {
  name = "forgeai-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgeai_cert" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgeai-cert"
      namespace = "forgeai-prod"
    }

    spec = {
      domains = ["prod.forgeai.probestack.io"]
    }
  }
}

resource "kubernetes_ingress_v1" "forgeai_ingress" {

  depends_on = [
    kubernetes_manifest.forgeai_cert,
    google_compute_global_address.forgeai_ip
  ]

  metadata {
    name      = "forgeai-ingress"
    namespace = "forgeai-prod"

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgeai_ip.name
      "networking.gke.io/managed-certificates"      = "forgeai-cert"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = "prod.forgeai.probestack.io"

      http {

        path {
          path      = "/ai-gateway"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-ai-gw"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "probestack-forgehub-frontend"
              port { number = 80 }
            }
          }
        }

      }
    }

    default_backend {
      service {
        name = "probestack-forgehub-frontend"
        port { number = 80 }
      }
    }
  }
}