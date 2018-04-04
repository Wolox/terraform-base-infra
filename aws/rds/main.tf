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

# Create the database
# TODO: Remove hardcoded parameters
resource "aws_db_instance" "default" {
  allocated_storage       = 30
  storage_type            = "gp2"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  instance_class          = "${var.instance_type}"
  name                    = "${var.db_name}"
  username                = "${var.username}"
  password                = "${var.password}"
  availability_zone       = "${var.azs[0]}"
  db_subnet_group_name    = "${aws_db_subnet_group.default.id}"
  vpc_security_group_ids  = ["${var.security_group}"]
  skip_final_snapshot     = true
  identifier              = "${var.application}-${var.environment}"
  backup_retention_period = 7
  apply_immediately       = true
  multi_az                = "${var.multi_az}"
}

output "endpoint" {
  value = "${aws_db_instance.default.address}"
}

output "name" {
  value = "${aws_db_instance.default.name}"
}

output "username" {
  value = "${aws_db_instance.default.username}"
}
