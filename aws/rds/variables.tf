variable "environment" {}
variable "application" {}
variable "db_name" {}
variable "username" {}
variable "password" {}
variable "security_group" {}
variable "engine" {}
variable "engine_version" {}

variable "azs" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "multi_az" {
  default = false
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.application}-${var.environment}"
  subnet_ids = ["${var.subnets}"]
}
