provider "google-beta" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.credentials
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "public_bucket" {
  name          = var.bucket_name
  project       = var.project
  storage_class = var.storage_class
  location      = var.bucket_location
}
