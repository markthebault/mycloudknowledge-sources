all: packer vpcs connect-vpcs

vpcs:
	make --directory ./terraform-network all

packer:
	make --directory ./vyos-image all

connect-vpcs:
	make --directory ./vpn-generated-configurations all


vpcs.down:
	make --directory ./terraform-network terraform-down