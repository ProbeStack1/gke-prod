resource "google_compute_global_address" "dev_ip" {
  name        = "probestack-dev-ingress-ip"
  description = "Static IP for dev Ingress"

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_manifest" "dev_cert" {
  depends_on = [
    kubernetes_namespace.dev,
    time_sleep.wait_for_gke
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "probestack-dev-cert"
      namespace = kubernetes_namespace.dev.metadata[0].name
    }

    spec = {
      domains = ["dev.probestack.io"]
    }
  }
}

resource "kubernetes_ingress_v1" "dev_ingress" {

  depends_on = [
    kubernetes_manifest.dev_cert,
    kubernetes_manifest.dev_frontend_config,
    google_compute_global_address.dev_ip
  ]

  metadata {
    name      = "dev-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.dev_ip.name
      "networking.gke.io/managed-certificates"      = "probestack-dev-cert"
      "networking.gke.io/frontend-config"           = "dev-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {
    rule {
      host = "dev.probestack.io"

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
          path      = "/wso2/config/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-profile-config-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/wso2/discovery/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-discovery-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/wso2/migration/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-migration-service"
              port { number = 80 }
            }
          }
        }
        path {
          path      = "/wso2/validation/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-validation-service"
              port { number = 80 }
            }
          }
        }
        path {
          path      = "/wso2/cutover/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-cutover-service"
              port { number = 80 }
            }
          }
        }

        path {
          path      = "/wso2/assessment/v1"
          path_type = "Prefix"

          backend {
            service {
              name = "forgeshift-wso2-assessment-service"
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
      namespace = "forgeq-dev"
    }

    spec = {
      domains = ["dev.forgeq.probestack.io"]
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
          path      = "/api/v1/ai"
          path_type = "Prefix"
          backend {
            service {
              name = "forgeq-ai-assistant-svc"
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

resource "kubernetes_manifest" "forgestudio_cert_v4" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name      = "forgestudio-cert-v4"
      namespace = "forgestudio-dev"
    }

    spec = {
      domains = [
        "dev.forgestudio.probestack.io",
        "dev.forgesphere.probestack.io",
        "dev.forgehub.probestack.io",
        "dev.forgeai.probestack.io",
        "dev.forgekonnect.probestack.io"
      ]
    }
  }
}

resource "kubernetes_ingress_v1" "forgestudio_ingress" {

  depends_on = [
    kubernetes_manifest.forgestudio_cert_v4,
    kubernetes_manifest.forgestudio_frontend_config,
    google_compute_global_address.forgestudio_ip,
    kubernetes_service_v1.nginx_gateway_svc
  ]

  metadata {
    name      = "forgestudio-ingress"
    namespace = "forgestudio-dev"

    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.forgestudio_ip.name
      "networking.gke.io/managed-certificates"      = "forgestudio-cert-v4"
      "networking.gke.io/frontend-config"           = "forgestudio-frontend-config"
      "kubernetes.io/ingress.allow-http"            = "true"
    }
  }

  spec {

    ########################################
    # FORGESTUDIO DOMAIN
    ########################################
    rule {
      host = var.forgestudio_domain

      http {
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
          path      = "/api/v1/collab"
          path_type = "Prefix"
          backend {
            service {
              name = "fs-collaboration-svc"
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
          path      = "/api/v1/sdk"
          path_type = "Prefix"
          backend {
            service {
              name = "fs-sdkgenerator-svc"
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

    ########################################
    # FORGESPHERE DOMAIN Ã¢â€ â€™ NGINX
    ########################################
    rule {
      host = "dev.forgesphere.probestack.io"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx-gateway-svc"
              port { number = 80 }
            }
          }
        }
      }
    }

    rule {
      host = "dev.forgehub.probestack.io"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx-gateway-svc"
              port { number = 80 }
            }
          }
        }
      }
    }

    rule {
      host = "forgeai.probestack.io"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx-gateway-svc"
              port { number = 80 }
            }
          }
        }
      }
    }

    rule {
      host = "forgekonnect.probestack.io"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "nginx-gateway-svc"
              port { number = 80 }
            }
          }
        }
      }
    }

    ########################################
    # DEFAULT BACKEND
    ########################################
    default_backend {
      service {
        name = "forgestudio-fe"
        port { number = 80 }
      }
    }
  }
}

resource "kubernetes_service_v1" "nginx_gateway_svc" {
  metadata {
    name      = "nginx-gateway-svc"
    namespace = "forgestudio-dev"
  }

  spec {
    selector = {
      app = "nginx-gateway"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}


