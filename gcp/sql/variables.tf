# Docs: https://www.terraform.io/docs/providers/google/r/redis_instance.html

variable project_id {} # Required

variable database_version { # Optional: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
  default = "POSTGRES_9_6"
}

variable zone { # Optional: https://cloud.google.com/sql/docs/mysql/instance-locations
  default = "us-east1-a"
}
variable region { # Optional: https://cloud.google.com/sql/docs/mysql/instance-locations
  default = "us-east1"
}

variable db_username {} # Required

variable db_password {} # Required

variable db_database_name {} # Required