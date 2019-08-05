///////////////////////////////////////
////////////// AWS DC1
//////////////////////////////////////
data "aws_ami" "latest_ecs" {
  most_recent = true
  owners      = ["591542846629"] # AWS

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
locals {
  aws_cassandra_userdata_seed = <<USERDATA
#!/bin/bash
ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

docker run --name cassandra-seed --restart unless-stopped --net host -d \
    -e CASSANDRA_CLUSTER_NAME=hybrid-cluster \
    -e CASSANDRA_DC=aws-dc \
    -e CASSANDRA_BROADCAST_ADDRESS=$ip \
    -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
    cassandra:3.11.4
USERDATA


  aws_cassandra_userdata_node = <<USERDATA
#!/bin/bash
sleep 120
ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')

docker run --name cassandra-node --restart unless-stopped --net host -d \
    -e CASSANDRA_CLUSTER_NAME=hybrid-cluster \
    -e CASSANDRA_DC=aws-dc \
    -e CASSANDRA_BROADCAST_ADDRESS=$ip \
    -e CASSANDRA_SEEDS=10.0.101.11 \
    -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
    cassandra:3.11.4
USERDATA
}

resource "aws_instance" "cass1" {
  count = (var.enable_cassandra == true ? 1 : 0)

  ami                    = "${data.aws_ami.latest_ecs.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.aws_instance.id}"]
  key_name               = "${aws_key_pair.deployer.id}"
  user_data              = local.aws_cassandra_userdata_seed

  private_ip = "10.0.101.11"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Cassandra1"
  }
}

resource "aws_instance" "cass2" {
  count = (var.enable_cassandra == true ? 1 : 0)

  ami                    = "${data.aws_ami.latest_ecs.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.aws_instance.id}"]
  key_name               = "${aws_key_pair.deployer.id}"
  user_data              = local.aws_cassandra_userdata_node

  private_ip = "10.0.101.12"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Cassandra2"

  }
}

resource "aws_instance" "cass3" {
  count = (var.enable_cassandra == true ? 1 : 0)

  ami                    = "${data.aws_ami.latest_ecs.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${module.aws_vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.aws_instance.id}"]
  key_name               = "${aws_key_pair.deployer.id}"
  user_data              = local.aws_cassandra_userdata_node

  private_ip = "10.0.101.13"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Cassandra3"

  }
}



/////////////////////////////////////////////
////////////////// GCP DC2
////////////////////////////////////////////

# data "google_compute_image" "container_image" {
# #   family  = "cos-stable"
#   name    = "cos-stable-75-12105-97-0"
# }

resource "google_compute_firewall" "cassandra_private_network" {
  name    = "allow-cassandra-private-net"
  network = module.gcp_vpc.network_name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/8"]


  target_tags = ["cassandra-private"]
}

resource "google_compute_address" "cassandra_seed" {
  name = "cassandra-address"
}

resource "google_compute_instance" "gcp_cassandra1" {
  count = (var.enable_cassandra == true ? 1 : 0)

  name         = "gcp-cassandra1"
  machine_type = "g1-small"
  zone         = "${var.gcp_region}-b"

  tags = ["cassandra-private", "web-icmp", "ssh-internet"]

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-75-12105-97-0"
    }
  }

  network_interface {
    subnetwork = module.gcp_vpc.subnets_names[0]

    access_config {
      nat_ip = "${google_compute_address.cassandra_seed.address}"
    }
  }

  metadata = {
    Environment = "Dev"
    Tier        = "Public"
    ssh-keys    = "James.Bond:${file("~/.ssh/id_rsa.pub")}"
    user-data   = <<USERDATA
#!/bin/bash
sleep 120
sudo iptables -w -A INPUT -p tcp -s 0.0.0.0/0 -j ACCEPT
sudo iptables -w -A INPUT -p udp -s 0.0.0.0/0 -j ACCEPT

ip=$(ip -o -4 addr show eth0 | awk -F '[ /]+' '/global/ {print $4}')

docker run --name cassandra-seed --restart unless-stopped --net host -d \
    -e CASSANDRA_CLUSTER_NAME=hybrid-cluster \
    -e CASSANDRA_DC=gcp-dc \
    -e CASSANDRA_BROADCAST_ADDRESS=$ip \
    -e CASSANDRA_SEEDS=$ip,10.0.101.11 \
    -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
    cassandra:3.11.4
USERDATA
  }
}

resource "google_compute_instance" "gcp_cassandra2" {
  count = (var.enable_cassandra == true ? 1 : 0)

  name = "gcp-cassandra2"
  machine_type = "g1-small"
  zone = "${var.gcp_region}-b"

  tags = ["cassandra-private", "web-icmp", "ssh-internet"]

  boot_disk {
    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-75-12105-97-0"
    }
  }

  network_interface {
    subnetwork = module.gcp_vpc.subnets_names[0]

  }

  metadata = {
    Environment = "Dev"
    Tier = "Public"
    ssh-keys = "James.Bond:${file("~/.ssh/id_rsa.pub")}"
    user-data = <<USERDATA
#!/bin/bash
sleep 240
sudo iptables -w -A INPUT -p tcp -s 0.0.0.0/0 -j ACCEPT
sudo iptables -w -A INPUT -p udp -s 0.0.0.0/0 -j ACCEPT

ip=$(ip -o -4 addr show eth0 | awk -F '[ /]+' '/global/ {print $4}')

docker run --name cassandra-node --restart unless-stopped --net host -d \
    -e CASSANDRA_CLUSTER_NAME=hybrid-cluster \
    -e CASSANDRA_DC=gcp-dc \
    -e CASSANDRA_BROADCAST_ADDRESS=$ip \
    -e CASSANDRA_SEEDS=${google_compute_instance.gcp_cassandra1[0].network_interface.0.network_ip} \
    -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
    cassandra:3.11.4
USERDATA
}
}
