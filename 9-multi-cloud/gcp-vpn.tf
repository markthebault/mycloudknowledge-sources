resource "google_compute_address" "gcp_vpn_ip" {
  name   = "gcp-vpn-ip"
  region = "${var.gcp_region}"
}

resource "google_compute_vpn_gateway" "gcp_vpn_gw" {
  name    = "gcp-vpn-gw-${var.gcp_region}"
  network = module.gcp_vpc.network_name
  region  = var.gcp_region
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.gcp_vpn_ip.address
  target      = google_compute_vpn_gateway.gcp_vpn_gw.self_link
}
resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = "${google_compute_address.gcp_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.gcp_vpn_gw.self_link}"
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = "${google_compute_address.gcp_vpn_ip.address}"
  target      = "${google_compute_vpn_gateway.gcp_vpn_gw.self_link}"
}
