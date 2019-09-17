variable "application" { }

variable "environment" { }

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {}

variable "app_security_group" { }

variable "node_type" {
  default = "cache.t2.micro"
}
