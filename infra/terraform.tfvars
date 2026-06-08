project_id  = "probestack-prod"

db_password = "Probe@stack!1" 

db_user     = "probestack_prod_admin"

db_tier     = "db-custom-2-7680"

domain_name = "probestack.io"

# ---------------------------------------------------------------------------
# GKE MASTER AUTHORIZED NETWORKS
# ---------------------------------------------------------------------------

# Add only approved public egress CIDRs that should reach the GKE control plane.
# Replace the values below with your real VPN, bastion, office, or CI/CD runner IPs.
#
# Example for a single public IP:
# cidr_block = "203.0.113.10/32"
#
# Do not use 0.0.0.0/0.

master_authorized_networks = [
  # Add your production VPN or office public IP here.
  {
    cidr_block   = "103.233.93.133/32"
    display_name = "saili-current-ip"
  },

  # Add your production CI/CD runner public egress IP here if Terraform runs from CI.
  # {
  #   cidr_block   = "YOUR_CI_RUNNER_PUBLIC_IP/32"
  #   display_name = "prod-ci-runner"
  # }
]

# ---------------------------------------------------------------------------
# DEFAULTS
# ---------------------------------------------------------------------------

# region      = "us-central1"

# Networking
# vpc_name    = "probestack-prod-vpc"
# subnet_name = "probestack-prod-subnet"

# GKE
# cluster_name = "secure-prod-cluster"
# artifact_repo_name = "probestack-prod-apps"
