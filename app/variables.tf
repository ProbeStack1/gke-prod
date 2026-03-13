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
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-cutover-service@sha256:c6b50f272b6867bb58eb17c10ea150f87d1dd3a26cc0d7dfb2f99f300e0e062b"
}

variable "apigee_edge_mock_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-edge-mock-service@sha256:cadd0a9f37aab8bb0e6b6c0be7e091d96b9febf7e714c71502440c8fa811a95e"
}

variable "probestack_apigee_assessment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-assessment-service@sha256:7d00126bead78161b6fbd42798e3dff6e2616f39357b81463b9ccd323e614cbf"
}

variable "probestack_apigee_deployment_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-deployments-service@sha256:8f9b878f87d3c65038f852da8b3974a90256d85d0a139eb83513207cc8df6011"
}

variable "probestack_apigee_discovery_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-discovery-service@sha256:7eebbcf0ed34f6d837465a3e86b780b635b28389a167d5353659e181803b114e"
}

variable "probestack_apigee_migration_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-migration-service@sha256:29e3e17ce329d7ea7d77e70fc34ea3d1e3c183c7e07cfbd8ab33fbfc39c10dcc"
}

variable "probestack_profile_config_service_image" {
  type    = string
  default = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-profile-config-service@sha256:8911c021de3ed6c1705b93584dc1668692178528b14c7beca4825fd218515329"
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

variable "mongodb_config_db" {
  type      = string
  sensitive = true
}

variable "auth0_client_secret" {
  type      = string
  sensitive = true
}