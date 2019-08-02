provider "aws" {
  region = var.aws_region
}
provider "google" {
  region      = var.gcp_region
  project     = var.gcp_project
  credentials = var.gcp_credentials
}
