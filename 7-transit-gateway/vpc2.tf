module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc2"

  cidr = "10.1.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  #private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  enable_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-2"
  }
}
