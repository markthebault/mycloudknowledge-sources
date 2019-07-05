variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {
  default = "wordpress_vpc"
}


variable "application_name" {
  default = "docker-wordpress"
}

variable "application_version" {
  default = "1"
}


variable "application_description" {
  default = "Basic wordpress installation"
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


