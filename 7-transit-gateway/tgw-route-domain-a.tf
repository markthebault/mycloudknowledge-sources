#routes for domain a = VPC1 and VPC2 together


resource "aws_ec2_transit_gateway_route_table" "domain_a" {
  transit_gateway_id = "${aws_ec2_transit_gateway.transit.id}"
}

###################VPC 1
resource "aws_ec2_transit_gateway_route_table_association" "vpc1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc1.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_a.id}"
}


resource "aws_ec2_transit_gateway_route_table_propagation" "vpc1" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc1.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_a.id}"
}

###################VPC 2
resource "aws_ec2_transit_gateway_route_table_association" "vpc2" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc2.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_a.id}"
}


resource "aws_ec2_transit_gateway_route_table_propagation" "vpc2" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.vpc2.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.domain_a.id}"
}


resource "aws_route" "vpc1tovpc2" {
  count                  = "${length(module.vpc1.public_route_table_ids)}"
  route_table_id         = "${module.vpc1.public_route_table_ids[count.index]}"
  destination_cidr_block = "${module.vpc2.vpc_cidr_block}"
  transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
}
resource "aws_route" "vpc2tovpc1" {
  count                  = "${length(module.vpc2.public_route_table_ids)}"
  route_table_id         = "${module.vpc2.public_route_table_ids[count.index]}"
  destination_cidr_block = "${module.vpc1.vpc_cidr_block}"
  transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
}
