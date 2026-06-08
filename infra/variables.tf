# CORE PROJECT SETTINGS

variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# NETWORK

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "probestack-dev-vpc"
}

variable "subnet_name" {
  description = "The name of the GKE subnet"
  type        = string
  default     = "probestack-dev-subnet"
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
  default     = "probestack-dev-router"
}

variable "nat_name" {
  description = "Name of the Cloud NAT"
  type        = string
  default     = "probestack-dev-nat"
}

variable "psa_range_name" {
  description = "Name of the reserved IP range for Private Service Access"
  type        = string
  default     = "google-managed-services-ip-range"
}

# GKE CLUSTER

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "probestack-dev-cluster"
}

variable "node_pool_name" {
  description = "The name of the primary node pool"
  type        = string
  default     = "main-pool"
}

variable "node_service_account" {
  description = "Service account name for GKE nodes"
  type        = string
  default     = "k8s-node-sa"
}

# ARTIFACT REGISTRY

variable "artifact_repo_name" {
  description = "The name of the artifact registry repository"
  type        = string
  default     = "probestack-dev-apps"
}

# INGRESS DOMAINS

variable "domain_name" {
  description = "Primary dev domain"
  type        = string
  default     = "dev.probestack.io"
}

variable "forgeq_domain" {
  description = "Domain for forgeq namespace"
  type        = string
  default     = "dev.forgeq.probestack.io"
}

variable "forgestudio_domain" {
  description = "Domain for forgestudio namespace"
  type        = string
  default     = "dev.forgestudio.probestack.io"
}

variable "forgeshift_domain" {
  description = "Domain for forgeshift namespace"
  type        = string
  default     = "dev.forgeshift.probestack.io"
}

variable "forgesphere_domain" {
  description = "Domain for forgesphere namespace"
  type        = string
  default     = "dev.forgesphere.probestack.io"
}

variable "forgeai_domain" {
  description = "Domain for forgeai namespace"
  type        = string
  default     = "dev.forgeai.probestack.io"
}

variable "forgehub_domain" {
  description = "Domain for forgehub namespace"
  type        = string
  default     = "dev.forgehub.probestack.io"
}

variable "forgekonnect_domain" {
  description = "Domain for forgekonnect namespace"
  type        = string
  default     = "dev.forgekonnect.probestack.io"
}


# CLOUD SQL

variable "db_instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
  default     = "probestack-mysql-nonprod"
}

variable "db_tier" {
  description = "The machine type for the Cloud SQL instance"
  type        = string
  default     = "db-custom-2-7680"
}

variable "db_user" {
  description = "The database admin username"
  type        = string
  default     = "probestack_dev_admin"
}

variable "db_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 12
    error_message = "DB password must be at least 12 characters long."
  }
}