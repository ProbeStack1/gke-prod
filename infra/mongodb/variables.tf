variable "atlas_project_id" {
  description = "MongoDB Atlas Project ID"
  type        = string
}

variable "atlas_public_key" {
  description = "MongoDB Atlas API public key"
  type        = string
  sensitive   = true
}

variable "atlas_private_key" {
  description = "MongoDB Atlas API private key"
  type        = string
  sensitive   = true
}

variable "atlas_cluster_name" {
  description = "Existing MongoDB Atlas cluster name"
  type        = string
}

variable "mongodb_password" {
  description = "Password for MongoDB application user"
  type        = string
  sensitive   = true
}
