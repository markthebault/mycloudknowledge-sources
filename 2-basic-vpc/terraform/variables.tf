variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "example-vpc"
}

variable "owner" {
  default = "James Bond"
}

variable "public_subnet1_cidr" {
  default = "10.0.1.0/24"
}
variable "private_subnet1_cidr" {
  default = "10.0.101.0/24"
}
variable "public_subnet2_cidr" {
  default = "10.0.2.0/24"
}
variable "private_subnet2_cidr" {
  default = "10.0.102.0/24"
}



