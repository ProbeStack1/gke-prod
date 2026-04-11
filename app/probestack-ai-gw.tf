resource "kubectl_manifest" "probestack_ai_gw_backend_config" {
  yaml_body = <<YAML
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: probestack-ai-gw-backend-config
  namespace: forgeai-prod
spec:
  healthCheck:
    port: 80
    requestPath: /
    type: HTTP
YAML
}

resource "kubernetes_deployment_v1" "probestack_ai_gw" {
  metadata {
    name      = "probestack-ai-gw"
    namespace = "forgeai-prod"

    labels = {
      app = "probestack-ai-gw"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "probestack-ai-gw"
      }
    }

    template {
      metadata {
        labels = {
          app = "probestack-ai-gw"
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
          name              = "probestack-ai-gw"
          image             = var.probestack_ai_gw_image
          image_pull_policy = "Always"

          port {
            container_port = 80
          }

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
            requests = {
              cpu    = "10m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
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

resource "kubernetes_service_v1" "probestack_ai_gw" {
  metadata {
    name      = "probestack-ai-gw"
    namespace = "forgeai-prod"

    labels = {
      app = "probestack-ai-gw"
    }

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"

      "cloud.google.com/backend-config" = jsonencode({
        ports = {
          "80" = "probestack-ai-gw-backend-config"
        }
      })
    }
  }

  spec {
    selector = {
      app = "probestack-ai-gw"
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
