locals {
  az1 = "${var.aws_region}a"
  az2 = "${var.aws_region}b"
}

resource "aws_vpc" "example" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name  = var.vpc_name
    Owner = var.owner
  }
}

# DHCP Options are not actually required, being identical to the Default Option Set
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name  = var.vpc_name
    Owner = var.owner
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.example.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}


############
## Subnets
############

# Subnet (public)
resource "aws_subnet" "example_public_az1" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = local.az1

  tags = {
    Name  = "example-public-${local.az1}"
    Type  = "Public subnet"
    Owner = var.owner
  }
}

resource "aws_subnet" "example_public_az2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.public_subnet2_cidr
  availability_zone = local.az2

  tags = {
    Name  = "example-public-${local.az2}"
    Type  = "Public subnet"
    Owner = var.owner
  }
}

# Subnet (private)
resource "aws_subnet" "example_private_az1" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = local.az1

  tags = {
    Name  = "example-private-${local.az1}"
    Type  = "Private subnet"
    Owner = var.owner
  }
}
resource "aws_subnet" "example_private_az2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = local.az2

  tags = {
    Name  = "example-private-${local.az2}"
    Type  = "Private subnet"
    Owner = var.owner
  }
}


############
## Internet access
############

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name  = "example-igw"
    Owner = var.owner
  }
}

#Nat Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}
resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.example_public_az1.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = ["aws_internet_gateway.gw"]
}

############
## Routing
############

#Public subnet
resource "aws_route_table" "example_public" {
  vpc_id = aws_vpc.example.id

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name  = "example-public-route"
    Owner = var.owner
  }
}

#Private subnet
resource "aws_route_table" "example_private" {
  vpc_id = aws_vpc.example.id

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name  = "example-private-route"
    Owner = var.owner
  }
}

## Associate subnets with routing tables
resource "aws_route_table_association" "example_public_az1" {
  subnet_id      = aws_subnet.example_public_az1.id
  route_table_id = aws_route_table.example_public.id
}
resource "aws_route_table_association" "example_public_az2" {
  subnet_id      = aws_subnet.example_public_az2.id
  route_table_id = aws_route_table.example_public.id
}

resource "aws_route_table_association" "example_private_az1" {
  subnet_id      = aws_subnet.example_private_az1.id
  route_table_id = aws_route_table.example_private.id
}
resource "aws_route_table_association" "example_private_az2" {
  subnet_id      = aws_subnet.example_private_az2.id
  route_table_id = aws_route_table.example_private.id
}
