variable "project_name" {}

variable "billing_account" {}

variable "org_id" {}

variable "project_editors" {
  default = []
}

variable "project_owners" {
  default = []
}

variable rds_memory_size_gb {
  default = 1
}

variable rds_tier {
  default = "BASIC"
}

variable rds_location_id { # https://cloud.google.com/appengine/docs/locations
  default = "us-central1-a"
}
