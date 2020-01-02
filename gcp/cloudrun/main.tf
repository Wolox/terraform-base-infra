variable project_id {} # Required

resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "run.googleapis.com"

  disable_dependent_services = true
}

resource "google_cloud_run_service" "default" {
  name     = "tftest-cloudrun"
  location = "us-central1"
  provider = "google-beta"
  project  = "${var.project_id}"

  metadata {
    namespace = "${var.project_id}"
  }

  spec {
    containers {
      image = "gcr.io/cloudrun/hello"
    }
  }

  depends_on = [
    "google_project_service.project",
  ]
}

# The Service is ready to be used when the "Ready" condition is True
# Due to Terraform and API limitations this is best accessed through a local variable
locals {
  cloud_run_status = {
    for cond in google_cloud_run_service.default.status[0].conditions :
    cond.type => cond.status
  }
}

output "isReady" {
  value = local.cloud_run_status["Ready"] == "True"
}
