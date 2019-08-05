
////////////////// Tunel 1
resource "google_compute_router" "gcp_router1" {
  name    = "gcp-router1"
  region  = var.gcp_region
  network = module.gcp_vpc.network_name
  bgp {
    asn = aws_customer_gateway.aws_cgw.bgp_asn
  }
}

resource "google_compute_vpn_tunnel" "gcp_tunnel1" {
  name          = "gcp-tunnel1"
  peer_ip       = aws_vpn_connection.vpn_con.tunnel1_address
  shared_secret = aws_vpn_connection.vpn_con.tunnel1_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gcp_vpn_gw.self_link

  router = google_compute_router.gcp_router1.name

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}



resource "google_compute_router_peer" "gcp_router1_peer" {
  name            = "gcp-to-aws-bgp1"
  router          = google_compute_router.gcp_router1.name
  region          = google_compute_router.gcp_router1.region
  peer_ip_address = aws_vpn_connection.vpn_con.tunnel1_vgw_inside_address
  peer_asn        = var.aws_asn
  interface       = google_compute_router_interface.router_interface1.name
}

resource "google_compute_router_interface" "router_interface1" {
  name       = "gcp-to-aws-interface1"
  router     = google_compute_router.gcp_router1.name
  region     = google_compute_router.gcp_router1.region
  ip_range   = "${aws_vpn_connection.vpn_con.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.gcp_tunnel1.name
}

////////////////// Tunel 2
resource "google_compute_router" "gcp_router2" {
  name    = "gcp-router2"
  region  = var.gcp_region
  network = module.gcp_vpc.network_name
  bgp {
    asn = aws_customer_gateway.aws_cgw.bgp_asn
  }
}

resource "google_compute_vpn_tunnel" "gcp_tunnel2" {
  name          = "gcp-tunnel2"
  peer_ip       = aws_vpn_connection.vpn_con.tunnel2_address
  shared_secret = aws_vpn_connection.vpn_con.tunnel2_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gcp_vpn_gw.self_link

  router = google_compute_router.gcp_router2.name

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]
}



resource "google_compute_router_peer" "gcp_router2_peer" {
  name            = "gcp-to-aws-bgp2"
  router          = google_compute_router.gcp_router2.name
  region          = google_compute_router.gcp_router2.region
  peer_ip_address = aws_vpn_connection.vpn_con.tunnel2_vgw_inside_address
  peer_asn        = var.aws_asn
  interface       = google_compute_router_interface.router_interface2.name
}

resource "google_compute_router_interface" "router_interface2" {
  name       = "gcp-to-aws-interface2"
  router     = google_compute_router.gcp_router2.name
  region     = google_compute_router.gcp_router2.region
  ip_range   = "${aws_vpn_connection.vpn_con.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.gcp_tunnel2.name
}
