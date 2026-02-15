############################################
# BackendConfig for GKE Load Balancer
############################################
resource "kubectl_manifest" "react_admin_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: react-admin-backend-config
  namespace: secure-production-app
spec:
  healthCheck:
    port: 80
    # UPDATED: Check / because nginx.conf has a dedicated 'location = /' block for health checks
    requestPath: /
    # Optional: Adjust timeouts if needed, but defaults are usually fine
    type: HTTP
YAML
}

############################################
# Deployment
############################################
resource "kubernetes_deployment_v1" "react_admin" {
  metadata {
    name      = "react-admin"
    namespace = "secure-production-app"

    labels = {
      app = "react-admin"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "react-admin"
      }
    }

    template {
      metadata {
        labels = {
          app = "react-admin"
        }
      }

      spec {
        security_context {
          run_as_non_root = true
          run_as_user     = 101
          fs_group        = 101

          seccomp_profile {
            type = "RuntimeDefault"
          }
        }

        container {
          name              = "react-admin"
          image             = var.react_admin_image
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

          ################################
          # Container security
          ################################
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

          ################################
          # Resources
          ################################
          resources {
            requests = {
              cpu    = "10m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          ################################
          # Probes MUST be "/"
          ################################
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

          ################################
          # Volumes
          ################################
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

############################################
# Service
############################################
resource "kubernetes_service_v1" "react_admin" {
  metadata {
    name      = "react-admin"
    namespace = "secure-production-app"

    labels = {
      app = "react-admin"
    }

    annotations = {
      # CRITICAL: Enable Container-Native Load Balancing (NEG)
      # This allows the Load Balancer to talk directly to Pod IP:80
      "cloud.google.com/neg" = "{\"ingress\": true}"
      
      "cloud.google.com/backend-config" = jsonencode({
        ports = {
          "80" = "react-admin-backend-config"
        }
      })
    }
  }

  spec {
    selector = {
      app = "react-admin"
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
