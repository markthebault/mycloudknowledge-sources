provider "google" {
  region      = var.gcp_region
  project     = var.gcp_project
  credentials = var.gcp_credentials
}
provider "google-beta" {
  version     = "~> 2.7.0"
  region      = var.gcp_region
  project     = var.gcp_project
  credentials = var.gcp_credentials
}
