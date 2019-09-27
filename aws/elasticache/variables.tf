variable "application" { }

variable "environment" { }

variable "azs" {
  type = "list"
}

variable "cache_private_subnets" {
  type = "list"

  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "server_public_subnet_cidr" {
  type = "list"
}

variable "vpc_id" {}

variable "app_security_group" { }

variable "node_type" {
  default = "cache.t2.micro"
}

variable "port" {
  default = 6379
}

variable "version" {
  default = "4.0.10"
}
