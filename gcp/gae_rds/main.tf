module "project" {
  source = "../project"

  project_name    = "${var.project_name}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
  owners          = "${var.project_owners}"
  editors         = "${var.project_editors}"
}

module "appengine" {
  source = "../appengine"

  project_id = "${module.project.project_id}"
  region     = "${var.region}"
}
module "cache" {
  source = "../redis"

  project_id     = "${module.project.project_id}"
  memory_size_gb = "${var.rds_memory_size_gb}"
  tier           = "${var.rds_tier}"
  zone           = "${var.rds_zone}"
  region         = "${var.region}"
}

module "sql" {
  source           = "../sql"
  project_id       = "${module.project.project_id}"
  region           = "${var.region}"
  zone             = "${var.zone}"
  db_username      = "${var.db_username}"
  db_password      = "${var.db_password}"
  db_database_name = "${var.db_database_name}"
}
