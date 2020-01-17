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

variable zone { # https://cloud.google.com/appengine/docs/locations
  default = "us-east1-a"
}

variable rds_zone { # https://cloud.google.com/memorystore/docs/redis/regions
  default = "us-east1-b"
}

variable region { # https://cloud.google.com/appengine/docs/locations
  default = "us-east1"
}

variable db_username {} # Required

variable db_password {} # Required

variable db_database_name {} # Required
