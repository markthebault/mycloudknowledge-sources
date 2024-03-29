module "aws_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "aws-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  # private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # database_subnets = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

  enable_vpn_gateway                 = true
  amazon_side_asn                    = var.aws_asn
  propagate_private_route_tables_vgw = true
  propagate_public_route_tables_vgw  = true

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "aws-vpc"
  }
}

resource "aws_customer_gateway" "aws_cgw" {
  bgp_asn    = var.gcp_asn
  ip_address = google_compute_address.gcp_vpn_ip.address
  type       = "ipsec.1"

  tags = {
    Name = "gcp vpn endpoint"
  }
}

resource "aws_vpn_connection" "vpn_con" {
  vpn_gateway_id      = module.aws_vpc.vgw_id
  customer_gateway_id = aws_customer_gateway.aws_cgw.id
  type                = "ipsec.1"
}
