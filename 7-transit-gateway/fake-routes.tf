# resource "aws_route" "vpc4_to_priv_class_a" {
#   count                  = "${length(module.vpc4.public_route_table_ids)}"
#   route_table_id         = "${module.vpc4.public_route_table_ids[count.index]}"
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
# }
# resource "aws_route" "vpc3_to_priv_class_a" {
#   count                  = "${length(module.vpc3.public_route_table_ids)}"
#   route_table_id         = "${module.vpc3.public_route_table_ids[count.index]}"
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
# }



# resource "aws_route" "vpc1_to_priv_class_a" {
#   count                  = "${length(module.vpc1.public_route_table_ids)}"
#   route_table_id         = "${module.vpc1.public_route_table_ids[count.index]}"
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
# }
# resource "aws_route" "vpc2_to_priv_class_a" {
#   count                  = "${length(module.vpc2.public_route_table_ids)}"
#   route_table_id         = "${module.vpc2.public_route_table_ids[count.index]}"
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id     = "${aws_ec2_transit_gateway.transit.id}"
# }
