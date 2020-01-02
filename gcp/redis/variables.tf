# Docs: https://www.terraform.io/docs/providers/google/r/redis_instance.html

variable project_id {} # Required

variable memory_size_gb { # Required
  default = 1
}

variable tier { # Optional
  default = "BASIC"
}

variable location_id { # Optional: https://cloud.google.com/appengine/docs/locations
  default = "us-central1-a"
}
