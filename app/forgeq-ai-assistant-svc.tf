resource "kubernetes_deployment_v1" "forgeq_ai_assistant_svc" {
  metadata {
    name      = "forgeq-ai-assistant-svc"
    namespace = "forgeq-dev"

    labels = {
      app = "forgeq-ai-assistant-svc"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "forgeq-ai-assistant-svc"
      }
    }

    template {
      metadata {
        labels = {
          app = "forgeq-ai-assistant-svc"
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
          name  = "forgeq-ai-assistant-svc"
          image = var.forgeq_ai_assistant_svc_image

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

          env {
            name  = "SERVER_SERVLET_CONTEXT_PATH"
            value = "/api/v1/ai"
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "cloud"
          }

          env {
            name  = "SPRING_CLOUD_GCP_PROJECT_ID"
            value = var.project_id
          }

          env {
            name = "MONGODB_URI"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mongodb_secret_forgeq.metadata[0].name
                key  = "MONGODB_URI"
              }
            }
          }

          env {
            name = "mongodb_config_db"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mongodb_secret_forgeq.metadata[0].name
                key  = "MONGODB_CONFIG_DB"
              }
            }
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

          env {
            name  = "SPRING_CLOUD_GCP_SQL_INSTANCE_CONNECTION_NAME"
            value = "${var.project_id}:${var.region}:probestack-mysql-dev"
          }

          env {
            name  = "SPRING_CLOUD_GCP_SQL_DATABASE_NAME"
            value = "probestack-dev-db"
          }

          readiness_probe {
            http_get {
              path = "/api/v1/ai/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
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

  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].image,
    ]
  }
}

resource "kubectl_manifest" "forgeq_ai_assistant_backend" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: forgeq-ai-assistant-backend
  namespace: forgeq-dev
spec:
  healthCheck:
    requestPath: /api/v1/ai/actuator/health
    port: 8080
    type: HTTP
YAML
}

resource "kubernetes_service_v1" "forgeq_ai_assistant_svc" {
  metadata {
    name      = "forgeq-ai-assistant-svc"
    namespace = "forgeq-dev"

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = jsonencode({
        default = "forgeq-ai-assistant-backend"
      })
    }

    labels = {
      app = "forgeq-ai-assistant-svc"
    }
  }

  spec {
    selector = {
      app = "forgeq-ai-assistant-svc"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}