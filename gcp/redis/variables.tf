# Docs: https://www.terraform.io/docs/providers/google/r/redis_instance.html

variable project_id {} # Required

variable memory_size_gb { # Required
  default = 1
}

variable tier { # Optional
  default = "BASIC"
}

variable zone { # Optional: https://cloud.google.com/memorystore/docs/redis/regions
  default = "us-east1-b"
}
variable region { # Optional: hhttps://cloud.google.com/memorystore/docs/redis/regions
  default = "us-east1"
}
