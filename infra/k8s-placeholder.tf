# COMMON LOCALS

locals {
  new_namespaces = {
    forgeq     = kubernetes_namespace.forgeq.metadata[0].name
    forgestudio     = kubernetes_namespace.forgestudio.metadata[0].name
    forgeshift = kubernetes_namespace.forgeshift.metadata[0].name
    forgesphere = kubernetes_namespace.forgesphere.metadata[0].name
    forgeai = kubernetes_namespace.forgeai.metadata[0].name
    forgehub = kubernetes_namespace.forgehub.metadata[0].name
    forgekonnect = kubernetes_namespace.forgekonnect.metadata[0].name
  }
}

# EXISTING PRODUCTION PLACEHOLDER

resource "kubernetes_deployment" "placeholder_prod" {

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
      match_labels = {
        app = "placeholder"
      }
    }

    template {
      metadata {
        labels = {
          app = "placeholder"
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
          name  = "nginx"
          image = "nginx:1.25-alpine"

          port {
            container_port = 80
          }

          security_context {
            allow_privilege_escalation = false
            run_as_non_root            = true
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
          }

          resources {
            requests = {
              cpu    = "25m"
              memory = "32Mi"
            }

            limits = {
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

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_service" "placeholder_prod" {

  metadata {
    name      = "placeholder"
    namespace = kubernetes_namespace.production.metadata[0].name

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
    }
  }

  spec {
    selector = {
      app = "placeholder"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# NEW PLACEHOLDERS

resource "kubernetes_deployment" "placeholder" {

  for_each = local.new_namespaces

  metadata {
    name      = "placeholder"
    namespace = each.value

    labels = {
      app = "placeholder"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "placeholder"
      }
    }

    template {
      metadata {
        labels = {
          app = "placeholder"
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
          name  = "nginx"
          image = "nginx:1.25-alpine"

          port {
            container_port = 80
          }

          security_context {
            allow_privilege_escalation = false
            run_as_non_root            = true
            read_only_root_filesystem  = true

            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
          }

          resources {
            requests = {
              cpu    = "25m"
              memory = "32Mi"
            }

            limits = {
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

  for_each = local.new_namespaces

  metadata {
    name      = "placeholder"
    namespace = each.value

    annotations = {
      "cloud.google.com/neg" = "{\"ingress\": true}"
    }
  }

  spec {
    selector = {
      app = "placeholder"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}