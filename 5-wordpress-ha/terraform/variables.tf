variable "aws_region" {
  default = "us-east-1"
}

variable "owner" {
  default = "James Bond"
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
