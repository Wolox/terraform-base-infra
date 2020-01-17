resource "google_project_service" "servicenetworking" {
  project = "${var.project_id}"
  service = "servicenetworking.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  project = "${var.project_id}"
  service = "compute.googleapis.com"

  disable_dependent_services = true
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project  = "${var.project_id}"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/${var.project_id}/global/networks/default"

  depends_on = ["google_project_service.servicenetworking", "google_project_service.compute"]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = "projects/${var.project_id}/global/networks/default"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = ["google_project_service.servicenetworking", "google_project_service.compute"]
}


resource "google_project_service" "vpcaccess" {
  project = "${var.project_id}"
  service = "vpcaccess.googleapis.com"

  disable_dependent_services = true
}

resource "google_vpc_access_connector" "connector" {
  project       = "${var.project_id}"
  name          = "my-connector"
  provider      = google-beta
  region        = "${var.region}"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"

  depends_on = ["google_project_service.vpcaccess"]
}

resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "sqladmin.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "sql_component" {
  project = "${var.project_id}"
  service = "sql-component.googleapis.com"

  disable_dependent_services = true
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project  = "${var.project_id}"

  name             = "db-${var.project_id}-${random_id.db_name_suffix.hex}"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  depends_on = ["google_project_service.project", "google_project_service.servicenetworking", "google_service_networking_connection.private_vpc_connection"]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      private_network = "projects/${var.project_id}/global/networks/default"
    }
  }
}

resource "google_sql_user" "users" {
  project  = "${var.project_id}"
  name     = "${var.db_username}"
  instance = google_sql_database_instance.instance.name
  password = "${var.db_password}"
}

resource "google_sql_database" "database" {
  project  = "${var.project_id}"
  name     = "${var.db_database_name}"
  instance = google_sql_database_instance.instance.name
}
