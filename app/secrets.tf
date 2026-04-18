resource "kubernetes_secret_v1" "cloudsql_db_secret" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "secure-production-app"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret" {
  metadata {
    name      = "mongodb-secret"
    namespace = "secure-production-app"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri
    MONGODB_CONFIG_DB = var.mongodb_config_db
  }
}

resource "kubernetes_secret_v1" "auth0_secret" {
  metadata {
    name      = "auth0-secret"
    namespace = "secure-production-app"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# ForgeQ Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgeq" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgeq-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgeq" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgeq-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgeq
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgeq
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgeq" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgeq-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# Forgestudio Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgestudio" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgestudio-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgestudio" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgestudio-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgestudio
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgestudio
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgestudio" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgestudio-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# Forgesphere Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgesphere" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgesphere-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgesphere" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgesphere-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgesphere
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgesphere
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgesphere" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgesphere-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# Forgeai Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgeai" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgeai-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgeai" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgeai-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgeai
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgeai
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgeai" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgeai-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# Forgehub Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgehub" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgehub-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgehub" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgehub-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgehub
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgehub
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgehub" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgehub-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}

# Forgekonnect Secrets

resource "kubernetes_secret_v1" "cloudsql_db_secret_forgekonnect" {
  metadata {
    name      = "cloudsql-db-secret"
    namespace = "forgekonnect-prod"
  }

  type = "Opaque"

  data = {
    password = var.cloudsql_password
  }
}

resource "kubernetes_secret_v1" "mongodb_secret_forgekonnect" {
  metadata {
    name      = "mongodb-secret"
    namespace = "forgekonnect-prod"
  }

  type = "Opaque"

  data = {
    MONGODB_URI       = var.mongodb_uri_forgekonnect
    MONGODB_CONFIG_DB = var.mongodb_config_db_forgekonnect
  }
}

resource "kubernetes_secret_v1" "auth0_secret_forgekonnect" {
  metadata {
    name      = "auth0-secret"
    namespace = "forgekonnect-prod"
  }

  type = "Opaque"

  data = {
    client_secret = var.auth0_client_secret
  }
}