module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name

  cidr = "10.0.0.0/16"
  azs  = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  #   database_subnets             = ["10.0.201.0/24", "10.0.202.0/24"]
  #   create_database_subnet_group = false


  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}
