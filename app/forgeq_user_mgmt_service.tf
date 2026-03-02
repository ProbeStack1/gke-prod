resource "kubernetes_deployment_v1" "forgeq_user_mgmt_service" {
  metadata {
    name      = "forgeq-user-mgmt-service"
    namespace = "secure-production-app"
    labels = {
      app = "forgeq-user-mgmt-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "forgeq-user-mgmt-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "forgeq-user-mgmt-service"
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
          name  = "forgeq-user-mgmt-service"
          image = var.forgeq_user_mgmt_image

          port {
            container_port = 8080
          }

          security_context {
            run_as_non_root            = true
            run_as_user                = 1001
            allow_privilege_escalation = false
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
            }
          }

          # =============================
          # SPRING CONTEXT PATH
          # =============================
          env {
            name  = "SERVER_SERVLET_CONTEXT_PATH"
            value = "/api/v1/users"
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "cloud"
          }

          env {
            name  = "SPRING_CLOUD_GCP_PROJECT_ID"
            value = var.project_id
          }

          # If using Cloud SQL
          env {
            name  = "SPRING_CLOUD_GCP_SQL_INSTANCE_CONNECTION_NAME"
            value = "${var.project_id}:${var.region}:probestack-mysql-prod"
          }

          env {
            name  = "SPRING_CLOUD_GCP_SQL_DATABASE_NAME"
            value = "probestack-prod-db"
          }

          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = var.cloudsql_user
          }

          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "cloudsql-db-secret"
                key  = "password"
              }
            }
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "300Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "1Gi"
            }
          }

          readiness_probe {
            http_get {
              path = "/api/v1/users/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/api/v1/users/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 60
            period_seconds        = 20
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
resource "kubectl_manifest" "forgeq_user_mgmt_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: forgeq-user-mgmt-backend-config
  namespace: secure-production-app
spec:
  healthCheck:
    requestPath: /api/v1/users/actuator/health
    port: 8080
    type: HTTP
YAML
}
resource "kubernetes_service_v1" "forgeq_user_mgmt_service" {
  metadata {
    name      = "forgeq-user-mgmt-service"
    namespace = "secure-production-app"

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = jsonencode({
        default = "forgeq-user-mgmt-backend-config"
      })
    }

    labels = {
      app = "forgeq-user-mgmt-service"
    }
  }

  spec {
    selector = {
      app = "forgeq-user-mgmt-service"
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