resource "aws_network_acl" "public_subnet" {
  vpc_id = "${aws_vpc.main.id}"

  subnet_ids = ["${aws_subnet.public.*.id}"]

  tags {
    Name = "public-subnet"
  }
}

resource "aws_network_acl_rule" "public_subnet_http_ingress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = false
  protocol        = "tcp"
  rule_number     = "100"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80
}

resource "aws_network_acl_rule" "public_subnet_https_ingress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = false
  protocol        = "tcp"
  rule_number     = "110"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443
}

resource "aws_network_acl_rule" "public_subnet_return_traffic_ingress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = false
  protocol        = "tcp"
  rule_number     = "120"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 1024
  to_port         = 65535
}

resource "aws_network_acl_rule" "public_subnet_ssh_ingress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = false
  protocol        = "tcp"
  rule_number     = "130"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 22
  to_port         = 22
}

resource "aws_network_acl_rule" "public_subnet_http_egress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = true
  protocol        = "tcp"
  rule_number     = "100"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 80
  to_port         = 80
}

resource "aws_network_acl_rule" "public_subnet_https_egress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = true
  protocol        = "tcp"
  rule_number     = "110"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 443
  to_port         = 443
}

resource "aws_network_acl_rule" "public_subnet_return_traffic_egress" {
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = true
  protocol        = "tcp"
  rule_number     = "120"
  rule_action     = "allow"
  cidr_block      = "0.0.0.0/0"
  from_port       = 32768
  to_port         = 65535
}

resource "aws_network_acl_rule" "public_subnet_private_dbs_egress" {
  count           = "${length(var.azs)}"
  network_acl_id  = "${aws_network_acl.public_subnet.id}"
  egress          = true
  protocol        = "tcp"
  rule_number     = "15${count.index}"
  rule_action     = "allow"
  cidr_block      = "${aws_subnet.private_dbs.*.cidr_block[count.index]}"
  from_port       = "${var.db_port}"
  to_port         = "${var.db_port}"
}
