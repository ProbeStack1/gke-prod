resource "kubernetes_deployment_v1" "admin_backend" {
  metadata {
    name      = "admin-backend"
    namespace = "secure-production-app"
    labels = {
      app = "admin-backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "admin-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "admin-backend"
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 1001
          fs_group        = 1001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name  = "admin-backend"
          image = var.admin_backend_image

          port {
            container_port = 8080
          }

          # REQUIRED for PodSecurity restricted
          security_context {
            run_as_non_root            = true
            run_as_user                = 1001
            allow_privilege_escalation = false
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
            }
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/api"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }

          env {
            name  = "ROOT_PATH"
            value = "/admin-backend"
          }

          env {
            name  = "DB_NAME"
            value = "probestack-prod-db"
          }

          env {
            name  = "DB_USER"
            value = var.cloudsql_user
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "cloudsql-db-secret"
                key  = "password"
              }
            }
          }

          env {
            name  = "INSTANCE_CONNECTION_NAME"
            value = "${var.project_id}:${var.region}:probestack-mysql-prod"
          }

          env {
            name = "MONGODB_URI"
            value_from {
              secret_key_ref {
                name = "mongodb-secret"
                key  = "MONGODB_URI"
              }
            }
          }

          env {
            name  = "AUTH0_DOMAIN"
            value = "probestack-usa-prod.us.auth0.com"
          }

          env {
            name  = "AUTH0_CLIENT_ID"
            value = "3iWcIhLljSPnbGbkQXsSMuPyTQksh8OF"
          }

          env {
            name  = "AUTH0_CALLBACK_URI"
            value = "https://${var.domain_name}/callback"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubectl_manifest" "admin_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: admin-backend-config
  namespace: secure-production-app
spec:
  healthCheck:
    requestPath: /docs
    type: HTTP
  urlRewrite:
    pathPrefixRewrite: /
YAML
}

resource "kubernetes_service_v1" "admin_backend" {
  metadata {
    name      = "admin-backend"
    namespace = "secure-production-app"

    annotations = {
      "cloud.google.com/neg"            = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = "{\"default\": \"admin-backend-config\"}"
    }

    labels = {
      app = "admin-backend"
    }
  }

  spec {
    selector = {
      app = "admin-backend"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "NodePort"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
}
