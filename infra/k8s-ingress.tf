resource "kubernetes_ingress_v1" "prod_ingress" {

  metadata {
    name      = "prod-ingress"
    namespace = "secure-production-app"

    annotations = {
      "kubernetes.io/ingress.class" = "gce"
    }
  }

  spec {

    ingress_class_name = "gce"

    rule {
      host = var.domain_name

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "placeholder"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}