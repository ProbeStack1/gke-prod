resource "kubernetes_deployment_v1" "forgeshift_wso2_validation_service" {
  metadata {
    name      = "forgeshift-wso2-validation-service"
    namespace = "probestack-dev"
    labels = {
      app = "forgeshift-wso2-validation-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "forgeshift-wso2-validation-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "forgeshift-wso2-validation-service"
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
          name  = "forgeshift-wso2-validation-service"
          image = var.forgeshift_wso2_validation_service_image

          port {
            container_port = 8085
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
            value = "/wso2/validation/v1"
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
            name = "mongodb_config_db"
            value_from {
              secret_key_ref {
                name = "mongodb-secret"
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
              path = "/wso2/validation/v1/actuator/health"
              port = 8085
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/wso2/validation/v1/actuator/health"
              port = 8085
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

resource "kubectl_manifest" "forgeshift_wso2_validation_service_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: forgeshift-wso2-validation-service-backend-config
  namespace: probestack-dev
spec:
  timeoutSec: 300
  healthCheck:
    requestPath: /wso2/validation/v1/actuator/health
    port: 8085
    type: HTTP
YAML
}

resource "kubernetes_service_v1" "forgeshift_wso2_validation_service" {
  metadata {
    name      = "forgeshift-wso2-validation-service"
    namespace = "probestack-dev"

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = jsonencode({
        default = "forgeshift-wso2-validation-service-backend-config"
      })
    }

    labels = {
      app = "forgeshift-wso2-validation-service"
    }
  }

  spec {
    selector = {
      app = "forgeshift-wso2-validation-service"
    }

    port {
      port        = 80
      target_port = 8085
    }

    type = "NodePort"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
}

