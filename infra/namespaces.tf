resource "kubernetes_namespace" "dev" {
  metadata {
    name = "probestack-dev"

    labels = {
      environment = "dev"
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
    name = "forgeq-dev"

    labels = {
      environment = "dev"
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
    name = "forgeshift-dev"

    labels = {
      environment = "dev"
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
    name = "forgestudio-dev"

    labels = {
      environment = "dev"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }
}

resource "kubernetes_namespace" "forgesphere" {
  metadata {
    name = "forgesphere-dev"

    labels = {
      environment = "dev"
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
    name = "forgeai-dev"

    labels = {
      environment = "dev"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }
}

resource "kubernetes_namespace" "forgekonnect" {
  metadata {
    name = "forgekonnect-dev"

    labels = {
      environment = "dev"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }
}

resource "kubernetes_namespace" "forgehub" {
  metadata {
    name = "forgehub-dev"

    labels = {
      environment = "dev"
      tier        = "backend"

      "pod-security.kubernetes.io/enforce"         = "restricted"
      "pod-security.kubernetes.io/enforce-version" = "v1.28"
      "pod-security.kubernetes.io/warn"            = "restricted"
      "pod-security.kubernetes.io/audit"           = "restricted"
    }
  }
}