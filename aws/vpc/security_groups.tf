resource "aws_security_group" "servers" {
  name   = "${var.application}-${var.environment}-server-sg"
  vpc_id = "${aws_vpc.main.id}"

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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the database and allow access from server server
resource "aws_security_group" "dbs" {
  name   = "${var.application}-db-sg"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port       = "${var.db_port}"
    to_port         = "${var.db_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.servers.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.servers.id}"]
  }
}
