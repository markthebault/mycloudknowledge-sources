resource "aws_ec2_transit_gateway" "transit" {
  description = "example"
}


## Attach VPC to the transit gateway but don't create TGW route tables
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1" {
  subnet_ids                                      = "${module.vpc1.public_subnets}"
  transit_gateway_id                              = "${aws_ec2_transit_gateway.transit.id}"
  vpc_id                                          = "${module.vpc1.vpc_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2" {
  subnet_ids                                      = "${module.vpc2.public_subnets}"
  transit_gateway_id                              = "${aws_ec2_transit_gateway.transit.id}"
  vpc_id                                          = "${module.vpc2.vpc_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3" {
  subnet_ids                                      = "${module.vpc3.public_subnets}"
  transit_gateway_id                              = "${aws_ec2_transit_gateway.transit.id}"
  vpc_id                                          = "${module.vpc3.vpc_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}


resource "aws_ec2_transit_gateway_vpc_attachment" "vpc4" {
  subnet_ids                                      = "${module.vpc4.public_subnets}"
  transit_gateway_id                              = "${aws_ec2_transit_gateway.transit.id}"
  vpc_id                                          = "${module.vpc4.vpc_id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}



