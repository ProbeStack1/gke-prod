resource "mongodbatlas_project_ip_access_list" "gke" {
  project_id = var.atlas_project_id
  ip_address = data.terraform_remote_state.infra.outputs.gke_nat_ip
  
  comment    = "GKE Cloud NAT egress (Production)"
}