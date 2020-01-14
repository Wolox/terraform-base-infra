resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "redis.googleapis.com"

  disable_dependent_services = true
}

resource "google_redis_instance" "cache" {
  name           = "${var.project_id}-redis"
  memory_size_gb = "${var.memory_size_gb}"
  project        = "${var.project_id}"
  tier           = "${var.tier}"
  region         = "${var.region}"
  location_id    = "${var.zone}"
  depends_on = [
    "google_project_service.project",
  ]
}
