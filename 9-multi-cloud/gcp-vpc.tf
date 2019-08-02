module "gcp_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 1.0.0"

  project_id   = var.gcp_project
  network_name = "gcp-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "sbn-public-1"
      subnet_ip     = "10.1.101.0/24"
      subnet_region = var.gcp_region
    },
    {
      subnet_name           = "sbn-private-1"
      subnet_ip             = "10.1.2.0/24"
      subnet_region         = var.gcp_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
  secondary_ranges = {
    sbn-public-1  = [],
    sbn-private-1 = []
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}


resource "google_compute_firewall" "default" {
  name    = "allow-icmp"
  network = module.gcp_vpc.network_name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]


  source_tags = ["web-icmp"]
}
