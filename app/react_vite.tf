resource "kubernetes_deployment_v1" "react_vite" {
  metadata {
    name      = "react-vite"
    namespace = "secure-production-app"
    labels = {
      app = "react-vite"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "react-vite"
      }
    }

    template {
      metadata {
        labels = {
          app = "react-vite"
        }
      }

      spec {
        # POD security context
        security_context {
          run_as_non_root = true
          run_as_user     = 101
          fs_group        = 101

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name  = "react-vite"
          image = var.react_vite_image

          port {
            container_port = 80
          }

          # ✅ SINGLE container security_context
          security_context {
            run_as_non_root            = true
            run_as_user                = 101
            allow_privilege_escalation = false
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 15
            period_seconds        = 20
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
          volume_mount {
            name       = "var-cache"
            mount_path = "/var/cache/nginx"
          }
          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }
        volume {
          name = "var-cache"
          empty_dir {}
        }
        volume {
          name = "var-run"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "react_vite" {
  metadata {
    name      = "react-vite"
    namespace = "secure-production-app"
    labels = {
      app = "react-vite"
    }

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
    }
  }

  spec {
    selector = {
      app = "react-vite"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cloud.google.com/neg-status"]
    ]
  }
}
