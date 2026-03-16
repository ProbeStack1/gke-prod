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
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-vite:1384b3b4837460c9109cb8dc66c70ad362b7f517"
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
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/admin-backend:bd9ada80b2cab702e447db545fd13a7c75846719"
}

variable "apigee_cutover_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-cutover:25b75cb8a6e369caeeed7075d6016cf9c19e3e6c"
}

variable "apigee_edge_mock_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-edge-mock-service@sha256:cadd0a9f37aab8bb0e6b6c0be7e091d96b9febf7e714c71502440c8fa811a95e"
}

variable "probestack_apigee_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-assessment-service:d084e4a568cfee056a6b453496aecab8e913de00"
}

variable "probestack_apigee_deployment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-deployments-service@sha256:8f9b878f87d3c65038f852da8b3974a90256d85d0a139eb83513207cc8df6011"
}

variable "probestack_apigee_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-discovery-service:3b39b47195c161f7716456b5e8be2a0e80c030c2"
}

variable "probestack_apigee_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-migration-service:92693902f69398b4576ae96da1988c7e31f7cc4f"
}

variable "probestack_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-profile-config-service:570fa32ca50f53bca5723ba4367b166d6484579b"
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
  default = "admin_dashboard"
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

variable "mongodb_config_db" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret" {
  type      = string
  sensitive = true
}