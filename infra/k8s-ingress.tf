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
          path      = "/load-tests"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-load-test-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/functional-tests"
          path_type = "Prefix"
          backend {
            service {
              name = "fq-functional-test-mgmt-svc"
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
          path      = "/kubetail"
          path_type = "Prefix"

          backend {
            service {
              name = "kubetail-dashboard"

              port {
                number = 8080
              }
            }
          }
        }
        path {
          path      = "/api/v1/specs"
          path_type = "Prefix"
          backend {
            service {
              name = "fs-apispec-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/endpoints"
          path_type = "Prefix"
          backend {
            service {
              name = "fs-apiwizard-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api/v1/projects"
          path_type = "Prefix"
          backend {
            service {
              name = "fs-project-svc"
              port { number = 80 }
            }
          }
        }

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

resource "google_compute_global_address" "forgesphere_ip" {
  name = "forgesphere-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgesphere_cert" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgesphere-cert"
      namespace = "forgesphere-prod"
    }

    spec = {
      domains = ["prod.forgesphere.probestack.io"] 
    }
  }
}

resource "kubernetes_ingress_v1" "forgesphere_ingress" {

  depends_on = [
    kubernetes_manifest.forgesphere_cert,
    kubernetes_manifest.forgesphere_frontend_config,
    google_compute_global_address.forgesphere_ip
  ]

  metadata {
    name      = "forgesphere-ingress"
    namespace = kubernetes_namespace.forgesphere.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgesphere_ip.name
      "networking.gke.io/managed-certificates"      = "forgesphere-cert"
      "networking.gke.io/frontend-config"           = "forgesphere-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = var.forgesphere_domain

      http {

        path {
          path      = "/api-design"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-api-design-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/api-development"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-api-development-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/mock-api"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-api-mock-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/consumer"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-consumer-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/contract-testing"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-contract-testing-svc"
              port { number = 80 }
            }
          }
        }
        
        path {
          path      = "/provider"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-provider-api-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/mock-api"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-api-mock-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/consumer"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-consumer-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/requirement"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-requirement-mgmt-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/test"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-test-generation-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/onboarding"
          path_type = "Prefix"
          backend {
            service {
              name = "fsp-onboarding-svc"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "forgesphere-fe"
              port { number = 80 }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "forgesphere-fe"
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
    kubernetes_manifest.forgeai_frontend_config,
    google_compute_global_address.forgeai_ip
  ]

  metadata {
    name      = "forgeai-ingress"
    namespace = kubernetes_namespace.forgeai.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgeai_ip.name
      "networking.gke.io/managed-certificates"      = "forgeai-cert"
      "networking.gke.io/frontend-config"           = "forgeai-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = var.forgeai_domain

      http {

        
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "forgeai-fe"
              port { number = 80 }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "forgeai-fe"
        port { number = 80 }
      }
    }
  }
}

resource "google_compute_global_address" "forgehub_ip" {
  name = "forgehub-ingress-ip"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "forgehub_cert" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgehub-cert"
      namespace = "forgehub-prod"
    }

    spec = {
      domains = ["prod.forgehub.probestack.io"] 
    }
  }
}

resource "kubernetes_ingress_v1" "forgehub_ingress" {

  depends_on = [
    kubernetes_manifest.forgehub_cert,
    kubernetes_manifest.forgehub_frontend_config,
    google_compute_global_address.forgehub_ip
  ]

  metadata {
    name      = "forgehub-ingress"
    namespace = kubernetes_namespace.forgehub.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgehub_ip.name
      "networking.gke.io/managed-certificates"      = "forgehub-cert"
      "networking.gke.io/frontend-config"           = "forgehub-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = var.forgehub_domain

      http {

        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "forgehub-fe"
              port { number = 80 }
            }
          }
        }
      }
    }

    default_backend {
      service {
        name = "forgehub-fe"
        port { number = 80 }
      }
    }
  }
}