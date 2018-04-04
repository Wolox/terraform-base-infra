# VPC Variables
variable "public_subnets" {
  type = "list"

  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "dbs_private_subnets" {
  type = "list"

  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}

# AWS Variables
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_azs" {
  type = "list"

  default = ["us-east-1a", "us-east-1b"]
}

# RDS Variables
variable "rds_db_name" {}

variable "rds_username" {}

variable "rds_password" {}

variable "rds_engine" {
  default = "postgres"
}

variable "rds_engine_version" {
  default = "9.6.6"
}

variable "rds_port" {
  default = "5432"
}

variable "rds_multi_az" {
  default = false
}

# EB Variables
variable "eb_application" {}

variable "eb_environment" {}

variable "eb_ec2_key_name" {}

variable "eb_solution_stack_name" {
  default = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
}

variable "eb_environment_type" {
  default = "SingleInstance"
}

variable "eb_instance_type" {
  default = "t2.small"
}
