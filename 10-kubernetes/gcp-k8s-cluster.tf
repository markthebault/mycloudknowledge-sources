module "gke_cluster" {
  source = "./modules/gke-cluster"

  name = var.cluster_name

  project  = var.gcp_project
  location = var.gcp_region

  network = module.vpc.network

  subnetwork                   = module.vpc.public_subnetwork
  cluster_secondary_range_name = module.vpc.public_subnetwork_secondary_range_name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SERVICE ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------
resource "google_service_account" "service_account" {
  project      = var.gcp_project
  account_id   = "gke-sa"
  display_name = "service account for k8s"
}

# Grant the service account the minimum necessary roles and permissions in order to run the GKE cluster
resource "google_project_iam_member" "service_account-log_writer" {
  project = google_service_account.service_account.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-metric_writer" {
  project = google_project_iam_member.service_account-log_writer.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-monitoring_viewer" {
  project = google_project_iam_member.service_account-metric_writer.project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-resource-metadata-writer" {
  project = google_project_iam_member.service_account-monitoring_viewer.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "main-pool"
  project  = var.gcp_project
  location = var.gcp_region
  cluster  = module.gke_cluster.name

  initial_node_count = "1"

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS"
    machine_type = "g1-small" #"n1-standard-1"

    labels = {
      all-pools-example = "true"
    }

    # Add a public tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
    tags = [
      "public-pool-example",
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = google_service_account.service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
