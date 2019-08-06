module "vpc" {
  source = "./modules/gcp-vpc"

  name_prefix = "${var.cluster_name}-network"
  project     = var.gcp_project
  region      = var.gcp_region

  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}

# resource "google_compute_firewall" "icmp_private_network" {
#   name    = "allow-icmp-private-net"
#   network = module.vpc.network_name

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["10.0.0.0/8"]


#   target_tags = ["web-icmp"]
# }


# resource "google_compute_firewall" "ssh_from_the_world" {
#   name    = "allow-ssh-internet"
#   network = module.vpc.network_name

#   allow {
#     protocol = "tcp"
#     ports    = [22]
#   }

#   source_ranges = ["0.0.0.0/0"]


#   target_tags = ["ssh-internet"]
# }
