data "google_compute_zones" "available" {}

variable project_id {}

resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "compute.googleapis.com"

  disable_dependent_services = true
}


resource "google_compute_instance" "default" {
  project      = "${var.project_id}"
  zone         = "${data.google_compute_zones.available.names[0]}"
  name         = "tf-compute-1"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
  depends_on = [
    "google_project_service.project",
  ]
}

output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}
