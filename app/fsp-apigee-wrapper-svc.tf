resource "kubernetes_deployment_v1" "fsp_apigee_wrapper_svc" {

  metadata {
    name      = "fsp-apigee-wrapper-svc"
    namespace = "forgesphere-prod"

    labels = {
      app = "fsp-apigee-wrapper-svc"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "fsp-apigee-wrapper-svc"
      }
    }

    template {

      metadata {
        labels = {
          app = "fsp-apigee-wrapper-svc"
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
          name  = "fsp-apigee-wrapper-svc"
          image = var.fsp_apigee_wrapper_svc_image

          ########################################
          # FIXED: App runs on port 3000
          ########################################
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

          env {
            name  = "SERVER_SERVLET_CONTEXT_PATH"
            value = "/apigee-wrapper"
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
                name = kubernetes_secret_v1.mongodb_secret_forgesphere.metadata[0].name
                key  = "MONGODB_URI"
              }
            }
          }

          env {
            name = "mongodb_config_db"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mongodb_secret_forgesphere.metadata[0].name
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
            value = "${var.project_id}:${var.region}:probestack-mysql-prod"
          }

          env {
            name  = "SPRING_CLOUD_GCP_SQL_DATABASE_NAME"
            value = "probestack-prod-db"
          }

          ########################################
          # FIXED: Readiness probe on port 3000
          ########################################
          readiness_probe {

            http_get {
              path = "/apigee-wrapper/health"
              port = 3000
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

########################################
# SERVICE
########################################

resource "kubernetes_service_v1" "fsp_apigee_wrapper_svc" {

  metadata {
    name      = "fsp-apigee-wrapper-svc"
    namespace = "forgesphere-prod"

    labels = {
      app = "fsp-apigee-wrapper-svc"
    }
  }

  spec {

    selector = {
      app = "fsp-apigee-wrapper-svc"
    }

    ########################################
    # FIXED: target_port -> 3000
    ########################################
    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}