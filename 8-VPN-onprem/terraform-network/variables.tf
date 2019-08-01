variable "aws_region" {
  default = "us-east-1"
}
variable "environment" {
  default = "dev"
}

variable "ami_vyos" {
}

variable "vyos_instance_type" {
  default = "t2.medium"
}

variable "key_pair_public_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "key_pair_private_path" {
  default = "~/.ssh/id_rsa"
}

variable "vyos_user" {
  default = "vyos"
}
