resource "kubernetes_deployment" "placeholder" {
  metadata {
    name      = "placeholder"
    namespace = kubernetes_namespace.production.metadata[0].name
    labels = {
      app = "placeholder"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "placeholder" }
    }

    template {
      metadata {
        labels = { app = "placeholder" }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 101 # Nginx user ID
          fs_group        = 101
          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name  = "nginx"
          image = "nginx:1.25-alpine"

          port {
            container_port = 80
          }

          security_context {
            allow_privilege_escalation = false
            # Explicitly set this again at container level to satisfy strict admission controllers
            run_as_non_root            = true 
            read_only_root_filesystem  = true
            
            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"] 
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
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

resource "kubernetes_service" "placeholder" {
  metadata {
    name      = "placeholder"
    namespace = kubernetes_namespace.production.metadata[0].name
    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
    }
  }

  spec {
    selector = { app = "placeholder" }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}