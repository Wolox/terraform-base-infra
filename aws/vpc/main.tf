variable "application" {}
variable "environment" {}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "dbs_private_subnets" {
  type = list(string)
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "db_port" {
  default = "5432"
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.application}-${var.environment}"
  }
}

resource "aws_default_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.application}-${var.environment}"
  }
}

/* Start Subnets */

resource "aws_subnet" "public" {
  count             = "${length(var.azs)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${var.azs[count.index]}"

  tags = {
    Name = "${var.application}-${var.environment}-public-${count.index}"
  }
}

resource "aws_subnet" "private_dbs" {
  count             = "${length(var.azs)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.dbs_private_subnets[count.index]}"
  availability_zone = "${var.azs[count.index]}"

  tags = {
    Name = "${var.application}-${var.environment}-private-dbs-${count.index}"
  }
}

/* End Subnets */

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${var.application}-${var.environment} public"
  }
}

resource "aws_default_route_table" "r" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  tags = {
    Name = "${var.application}-${var.environment} main"
  }
}

resource "aws_route_table_association" "a" {
  count          = "${length(var.azs)}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "private_dbs" {
  count          = "${length(var.azs)}"
  subnet_id      = "${aws_subnet.private_dbs.*.id[count.index]}"
  route_table_id = "${aws_default_route_table.r.id}"
}

/* Network ACLs */

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets_cidr" {
  value = ["${aws_subnet.public.*.cidr_block}"]
}

output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "servers_sg_id" {
  value = "${aws_security_group.servers.id}"
}

output "private_dbs_subnets_cidr" {
  value = ["${aws_subnet.private_dbs.*.cidr_block}"]
}

output "private_dbs_subnets" {
  value = "${aws_subnet.private_dbs.*.id}"
}

output "dbs_sg_id" {
  value = "${aws_security_group.dbs.id}"
}
