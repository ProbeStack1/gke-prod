resource "kubernetes_namespace" "production" {
  metadata {
    name = "secure-production-app"

    labels = {
      environment = "production"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }
}