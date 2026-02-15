resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "gke" {
  name                     = var.subnet_name
  region                   = var.region
  network                  = google_compute_network.vpc.id
  
  ip_cidr_range            = "10.0.0.0/20"
  
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.96.0.0/20"
  }
}