#routes for domain_b = vpc3 and vpc3 together


resource "aws_ec2_transit_gateway_route_table" "domain_b" {
  transit_gateway_id = "${aws_ec2_transit_gateway.transit.id}"
}

###################VPC 4
resource "aws_ec2_transit_gateway_route_table_association" "domain_b_vpc4" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc4.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_b.id}"
}


resource "aws_ec2_transit_gateway_route_table_propagation" "domain_b_vpc4" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc4.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_b.id}"
}

###################VPC 3
resource "aws_ec2_transit_gateway_route_table_association" "domain_b_vpc3" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc3.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_b.id}"
}


resource "aws_ec2_transit_gateway_route_table_propagation" "domain_b_vpc3" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc3.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_b.id}"
}


resource "aws_route" "vpc4tovpc3" {
  count                  = "${length(module.vpc4.public_route_table_ids)}"
  route_table_id         = "${module.vpc4.public_route_table_ids[count.index]}"
  destination_cidr_block = "${module.vpc3.vpc_cidr_block}"
  transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
}
resource "aws_route" "vpc3tovpc4" {
  count                  = "${length(module.vpc3.public_route_table_ids)}"
  route_table_id         = "${module.vpc3.public_route_table_ids[count.index]}"
  destination_cidr_block = "${module.vpc4.vpc_cidr_block}"
  transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
}
