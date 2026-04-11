resource "kubernetes_namespace" "production" {
  metadata {
    name = "secure-production-app"

    labels = {
      environment = "production"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_namespace" "forgeq" {
  metadata {
    name = "forgeq-prod"

    labels = {
      environment = "production"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }

}

resource "kubernetes_namespace" "forgeshift" {
  metadata {
    name = "forgeshift-prod"

    labels = {
      environment = "production"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }

}

resource "kubernetes_namespace" "forgestudio" {
  metadata {
    name = "forgestudio-prod"

    labels = {
      environment = "production"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }

}

resource "kubernetes_namespace" "forgeai" {
  metadata {
    name = "forgeai-prod"

    labels = {
      environment = "production"
      tier        = "frontend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }

}