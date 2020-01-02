// Docs: https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform

resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

resource "google_project_iam_member" "editor" {
  project = "${google_project.project.project_id}"
  role    = "roles/editor"
  count   = "${length(var.editors)}"
  member  = "${var.editors[count.index]}"
}

resource "google_project_iam_member" "project" {
  project = "${google_project.project.project_id}"
  role    = "roles/owner"
  count   = "${length(var.owners)}"
  member  = "${var.owners[count.index]}"
}
