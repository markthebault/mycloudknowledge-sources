module "vpc4" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc4"

  cidr = "10.3.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  #private_subnets = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]
  public_subnets = ["10.3.101.0/24", "10.3.102.0/24", "10.3.103.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-4"
  }
}
