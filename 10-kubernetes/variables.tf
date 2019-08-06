variable "gcp_region" {
  default = "us-east1"
}

variable "gcp_project" {
}


variable "cluster_name" {
  default = "k8some"
}

variable "gcp_credentials" {

}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vpc_secondary_cidr_block" {
  default = "172.16.0.0/16"
}
