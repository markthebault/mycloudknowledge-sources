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

variable "rds_name" {
  default = "wordpress-db"
}

variable "rds_master_user" {
  default = "master"
}

variable "rds_master_user_password" {
  default = "Master123!"
}
variable "rds_database" {
  default = "wordpress"
}



variable ec2_amis {
  description = "Default AMIs to use depending on the region"
  type        = "map"
  default = {
    eu-west-1 = "ami-04a084a6d17d9816e"
    us-east-1 = "ami-02507631a9f7bc956"
  }
}
