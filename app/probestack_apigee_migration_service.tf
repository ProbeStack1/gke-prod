resource "kubernetes_deployment_v1" "probestack_apigee_migration_service" {
  metadata {
    name      = "probestack-apigee-migration-service"
    namespace = "secure-production-app"
    labels = {
      app = "probestack-apigee-migration-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "probestack-apigee-migration-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "probestack-apigee-migration-service"
        }
      }

      spec {
        # POD security context
        security_context {
          run_as_non_root = true
          run_as_user     = 1001
          fs_group        = 1001

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name  = "probestack-apigee-migration-service"
          image = var.probestack_apigee_migration_service_image

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
            value = "/probestack/v1/apigee/migration"
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
                name = "mongodb-secret"
                key  = "MONGODB_URI"
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
            value = "${var.project_id}:${var.region}:probestack-mysql-prod"
          }

          env {
            name  = "SPRING_CLOUD_GCP_SQL_DATABASE_NAME"
            value = "probestack-prod-db"
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
              path = "/probestack/v1/apigee/migration/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
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

resource "kubectl_manifest" "probestack_apigee_migration_service_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: probestack-apigee-migration-service-backend-config
  namespace: secure-production-app
spec:
  healthCheck:
    requestPath: /probestack/v1/apigee/migration/actuator/health
    port: 8080
    type: HTTP
YAML
}

resource "kubernetes_service_v1" "probestack_apigee_migration_service" {
  metadata {
    name      = "probestack-apigee-migration-service"
    namespace = "secure-production-app"

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = jsonencode({
        default = "probestack-apigee-migration-service-backend-config"
      })
    }

    labels = {
      app = "probestack-apigee-migration-service"
    }
  }

  spec {
    selector = {
      app = "probestack-apigee-migration-service"
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
