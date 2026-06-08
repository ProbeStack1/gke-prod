resource "kubernetes_deployment_v1" "fsp_kong_wrapper_svc" {
  metadata {
    name      = "fsp-kong-wrapper-svc"
    namespace = "forgesphere-dev"

    labels = {
      app = "fsp-kong-wrapper-svc"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "fsp-kong-wrapper-svc"
      }
    }

    template {
      metadata {
        labels = {
          app = "fsp-kong-wrapper-svc"
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
          name  = "fsp-kong-wrapper-svc"
          image = var.fsp_kong_wrapper_image

          port {
            container_port = 3000
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

          ########################################
          # ENV
          ########################################
          env {
            name  = "PORT"
            value = "3000"
          }

          env {
            name  = "CONTEXT_PATH"
            value = "/kong-wrapper"
          }

          ########################################
          # HEALTH CHECK
          ########################################
          readiness_probe {
            http_get {
              path = "/kong-wrapper/health"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/kong-wrapper/health"
              port = 3000
            }
            initial_delay_seconds = 20
            period_seconds        = 20
          }

          ########################################
          # RESOURCES
          ########################################
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
resource "kubernetes_service_v1" "fsp_kong_wrapper_svc" {
  metadata {
    name      = "fsp-kong-wrapper-svc"
    namespace = "forgesphere-dev"

    labels = {
      app = "fsp-kong-wrapper-svc"
    }
  }

  spec {
    selector = {
      app = "fsp-kong-wrapper-svc"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}