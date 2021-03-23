provider "google-beta" {
  project     = var.project
  region      = var.location
  zone        = var.zone
  credentials = var.credentials
}

resource "google_compute_network" "net_cluster" {
  project                 = var.project
  provider                = google-beta
  name                    = "cluster-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet_cluster" {
  name          = "cluster-subnet"
  provider      = google-beta
  project       = var.project
  region        = var.location
  network       = google_compute_network.net_cluster.self_link
  ip_cidr_range = var.subnet_cidr

  secondary_ip_range {
    range_name    = "cluster-cidr"
    ip_cidr_range = var.subnet_cluster_cidr
  }
  secondary_ip_range {
    range_name    = "services-cidr"
    ip_cidr_range = var.subnet_services_cidr
  }
}


resource "google_container_cluster" "primary" {
  name       = var.cluster_name
  location   = var.location
  network    = google_compute_network.net_cluster.name           
  subnetwork = google_compute_subnetwork.subnet_cluster.name 

  remove_default_node_pool = true
  initial_node_count       = 1

  provider = google-beta

  release_channel {
    channel = "REGULAR"
  }

  # Enable Workload Identity
  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  maintenance_policy {
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#recurring_window
    recurring_window {
      start_time = var.daily_maintenance_window_start_time
      end_time   = var.daily_maintenance_window_end_time
      recurrence = var.daily_maintenance_recurrence
    }
  }

  addons_config {
    istio_config {
      disabled = true
    }
    cloudrun_config {
      disabled = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "nodes"
  location = var.location
  cluster  = google_container_cluster.primary.name

  provider = google-beta

  project = var.project

  autoscaling {
    min_node_count = var.autoscale_min_nodes
    max_node_count = var.autoscale_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
    machine_type = var.nodes_size
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

module "static_ip_ingress_gateway" {
  source      = "../static-ip-module"
  name        = "ingress-gateway-ip"
  credentials = var.credentials
}

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

//service account to use cloud sql proxy inside the cluster
module "my-app-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "db-service-account"
  namespace  = "default"
  project_id = var.project
  roles      = ["roles/cloudsql.client"]
}
