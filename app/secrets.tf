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
    MONGODB_URI       = var.mongodb_uri
    MONGODB_CONFIG_DB = var.mongodb_config_db
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
    MONGODB_URI       = var.mongodb_uri
    MONGODB_CONFIG_DB = var.mongodb_config_db
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