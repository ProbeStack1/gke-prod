variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

############################
# Network
############################

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "probestack-prod-vpc"
}

variable "subnet_name" {
  description = "The name of the GKE subnet"
  type        = string
  default     = "probestack-prod-subnet"
}

variable "router_name" {
  description = "Name of the Cloud Router"
  type        = string
  default     = "probestack-prod-router"
}

variable "nat_name" {
  description = "Name of the Cloud NAT"
  type        = string
  default     = "probestack-prod-nat"
}

variable "psa_range_name" {
  description = "Name of the reserved IP range for Private Service Access"
  type        = string
  default     = "google-managed-services-ip-range"
}

############################
# GKE Cluster
############################

variable "cluster_name" {
  description = "Name of the NEW optimized GKE cluster"
  type        = string

  # Important: new cluster so Terraform does NOT replace existing one
  default     = "probestack-cluster"
}

variable "node_pool_name" {
  description = "The name of the primary node pool"
  type        = string
  default     = "main-pool"
}

############################
# Artifact Registry
############################

variable "artifact_repo_name" {
  description = "The name of the artifact registry repository"
  type        = string
  default     = "probestack-prod-apps"
}

############################
# Ingress Domain
############################

variable "domain_name" {
  description = "Temporary domain for the new cluster during migration"
  type        = string

  # Prevents conflict with existing cluster ingress
  default     = "prod.probestack.io"
}

############################
# Cloud SQL
############################

variable "db_instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string

  # Must match existing DB so Terraform does NOT recreate it
  default     = "probestack-mysql-prod"
}

variable "db_tier" {
  description = "The machine type for the Cloud SQL instance"

  # Must match existing production DB
  type        = string
  default     = "db-custom-2-7680"
}

variable "db_user" {
  description = "The database admin username"
  type        = string

  # Must match existing DB user
  default     = "probestack_prod_admin"
}

variable "db_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true
}

variable "node_service_account" {
  default = "k8s-node-sa"
}