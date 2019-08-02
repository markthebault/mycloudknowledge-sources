variable "aws_region" {
  default = "us-east-1"
}
variable "fargate_cpu" {
  default = 512
}

variable "fargate_memory" {
  default = 1024
}
variable "wordpress_port" {
  default = 80
}

variable "mysql_port" {
  default = 3306
}

variable "wordpress_image" {
  default = "wordpress:php7.3-apache"
}

variable "mysql_image" {
  default = "mysql:5.7"
}

variable "wordpress_counts" {
  default = 2
}
