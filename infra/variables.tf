variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-central1"
}

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

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "secure-prod-cluster"
}

variable "node_pool_name" {
  description = "The name of the primary node pool"
  type        = string
  default     = "main-pool"
}

variable "artifact_repo_name" {
  description = "The name of the artifact registry repository"
  type        = string
  default     = "probestack-prod-apps"
}

variable "domain_name" {
  description = "The domain name for the production ingress (e.g., probestack.io)"
  type        = string
  default     = "probestack.io" 
}

variable "db_instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
  default     = "probestack-mysql-prod"
}

variable "db_tier" {
  description = "The machine type for the Cloud SQL instance"
  type        = string
  default     = "db-custom-2-7680" # 2 vCPU, 7.5 GB RAM (Production baseline)
}

variable "db_user" {
  description = "The database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The database admin password"
  type        = string
  sensitive   = true # Hides output in logs
}