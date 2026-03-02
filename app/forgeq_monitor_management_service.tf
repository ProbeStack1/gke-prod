resource "kubernetes_deployment_v1" "forgeq_monitor_management_service" {
  metadata {
    name      = "forgeq-monitor-management-service"
    namespace = "secure-production-app"
    labels = {
      app = "forgeq-monitor-management-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "forgeq-monitor-management-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "forgeq-monitor-management-service"
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
          name  = "forgeq-monitor-management-service"
          image = var.forgeq_monitor_management_image

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

          # Context path
          env {
            name  = "SERVER_SERVLET_CONTEXT_PATH"
            value = "/api/v1/monitors"
          }

          env {
            name  = "SPRING_PROFILES_ACTIVE"
            value = "cloud"
          }

          env {
            name  = "SPRING_CLOUD_GCP_PROJECT_ID"
            value = var.project_id
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
              path = "/api/v1/monitors/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/api/v1/monitors/actuator/health"
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
resource "kubectl_manifest" "forgeq_monitor_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: forgeq-monitor-backend-config
  namespace: secure-production-app
spec:
  healthCheck:
    requestPath: /api/v1/monitors/actuator/health
    port: 8080
    type: HTTP
YAML
}
resource "kubernetes_service_v1" "forgeq_monitor_management_service" {
  metadata {
    name      = "forgeq-monitor-management-service"
    namespace = "secure-production-app"

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
      "cloud.google.com/backend-config" = jsonencode({
        default = "forgeq-monitor-backend-config"
      })
    }

    labels = {
      app = "forgeq-monitor-management-service"
    }
  }

  spec {
    selector = {
      app = "forgeq-monitor-management-service"
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