########################################
# Provider to connect to AWS
#
# https://www.terraform.io/docs/providers/aws/
########################################


provider "aws" {
  region = "${var.aws_region}"
}
