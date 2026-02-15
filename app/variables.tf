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
  description = "The name of the GKE cluster (must match infra)"
  type        = string
  default     = "secure-prod-cluster"
}

variable "domain_name" {
  description = "The production domain name (e.g. prod.probestack.io)"
  type        = string
  default     = "prod.probestack.io"
}

variable "react_vite_image" {
  description = "React Vite Frontend Image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-vite:1.0"
}

variable "react_admin_image" {
  description = "React Admin Frontend Image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/react-admin:11.0"
}

variable "admin_backend_image" {
  description = "Admin Backend API Image"
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/admin-backend:5.0"
}

variable "apigee_cutover_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/cutover:1.0"
}

variable "apigee_edge_mock_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/apigee-edge-mock-service:1.0"
}

variable "probestack_apigee_assessment_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-assessment-service:1.0"
}

variable "probestack_apigee_deployment_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-deployments-service:1.0"
}

variable "probestack_apigee_discovery_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-discovery-service:1.0"
}

variable "probestack_apigee_migration_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-apigee-migration-service:1.0"
}

variable "probestack_profile_config_service_image" {
  type        = string
  default     = "us-central1-docker.pkg.dev/probestack-prod/probestack-prod-apps/probestack-profile-config-service:1.0"
}

variable "cloudsql_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-custom-2-7680"
}

variable "cloudsql_user" {
  description = "Cloud SQL DB user"
  type        = string
  default     = "probestack_prod_admin"
}

variable "cloudsql_password" {
  description = "Cloud SQL DB password"
  type        = string
  sensitive   = true
}

variable "mongodb_uri" {
  description = "MongoDB Connection URI"
  type        = string
  sensitive   = true
}

variable "auth0_client_secret" {
  description = "Auth0 Client Secret for Admin Backend"
  type        = string
  sensitive   = true
}