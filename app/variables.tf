variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The region of the GKE cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "probestack-cluster"
}

variable "domain_name" {
  description = "Temporary domain for new cluster during migration"
  type        = string
  default     = "prod.probestack.io"
}

############################
# Frontend Images
############################

variable "react_vite_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-vite:1.0"
}

variable "react_admin_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-admin:11.0"
}

############################
# Backend APIs
############################

variable "admin_backend_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/admin-backend:5.0"
}

variable "apigee_cutover_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-cutover-service@sha256:f2aac466f095ae0d9a30b0c49396ca98921036d963802209322a62b8a55c0d5c"
}

variable "apigee_edge_mock_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-edge-mock-service@sha256:cadd0a9f37aab8bb0e6b6c0be7e091d96b9febf7e714c71502440c8fa811a95e"
}

variable "probestack_apigee_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-assessment-service@sha256:0f66aa0f79767c6170345cfa8f0775e8ccd17d67d92cab4bbcd14abdda5d1801"
}

variable "probestack_apigee_deployment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-deployments-service@sha256:709544d3655548198e3f7673c5593e3501e5fbcf310084e79752f835e03083a2"
}

variable "probestack_apigee_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-discovery-service@sha256:6c2ae999bd73cf4c00147ecb67867b31598f6d2c4235eb1fb0552d649244f687"
}

variable "probestack_apigee_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-migration-service@sha256:84ae020eade9fc78487fe29a858e9daca751a3fd71ecec3d59b735f149fd2712"
}

variable "probestack_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-profile-config-service@sha256:199c704c5146b0d9a21268f601c937ffd23af0a92a5268792474758f368efc78"
}

############################
# ForgeQ Services
############################

variable "forgeq_user_mgmt_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-user-mgmt-service:1.0"
}

variable "forgeq_workspace_mgmt_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-workspace-mgmt-service:1.0"
}

variable "forgeq_collection_management_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-collection-management-service:1.0"
}

variable "forgeq_monitor_management_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/forgeq-monitor-management-service:1.0"
}

############################
# CloudSQL
############################

variable "cloudsql_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-g1-small"
}

variable "cloudsql_user" {
  type    = string
  default = "probestack_prod_admin"
}

variable "cloudsql_password" {
  type      = string
  sensitive = true
}

############################
# External Services
############################

variable "mongodb_uri" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret" {
  type      = string
  sensitive = true
}