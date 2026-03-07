############################################
# STATIC NAT IP
############################################

resource "google_compute_address" "nat_ip" {
  name   = "probestack-prod-nat-ip"
  region = var.region
}

############################################
# CLOUD ROUTER
############################################

resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region

  network = google_compute_network.vpc.id
}

############################################
# CLOUD NAT
############################################

resource "google_compute_router_nat" "nat" {
  name   = var.nat_name
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [
    google_compute_address.nat_ip.self_link
  ]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  min_ports_per_vm = 64

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}