data "google_compute_image" "debian_image" {
  family  = "debian-9"
  project = "debian-cloud"
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "default" {
  name         = "gcp-vm"
  machine_type = "g1-small"
  zone         = "${var.gcp_region}-b"

  #tags = ["web-icmp"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.debian_image.self_link}"
    }
  }



  network_interface {
    subnetwork = module.gcp_vpc.subnets_names[0]

    access_config {
      nat_ip = "${google_compute_address.static.address}"
    }
  }

  metadata = {
    foo = "bar"
  }
}
