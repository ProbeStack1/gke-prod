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
    MONGODB_URI = var.mongodb_uri
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