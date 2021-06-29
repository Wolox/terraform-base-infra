resource "aws_network_acl" "private_dbs_subnet" {
  vpc_id = "${aws_vpc.main.id}"

  subnet_ids = ["${aws_subnet.private_dbs.*.id}"]

  tags  = {
    Name = "private-dbs-subnet"
  }
}

resource "aws_network_acl_rule" "private_dbs_public_subnet_ingress" {
  network_acl_id = "${aws_network_acl.private_dbs_subnet.id}"
  egress         = false
  count          = "${length(var.azs)}"
  protocol       = "tcp"
  rule_number    = "11${count.index}"
  rule_action    = "allow"
  cidr_block     = "${aws_subnet.public.*.cidr_block[count.index]}"
  from_port      = "${var.db_port}"
  to_port        = "${var.db_port}"
}

resource "aws_network_acl_rule" "private_dbs_public_return_traffic" {
  network_acl_id = "${aws_network_acl.private_dbs_subnet.id}"
  egress         = true
  count          = "${length(var.azs)}"
  protocol       = "tcp"
  rule_number    = "13${count.index}"
  rule_action    = "allow"
  cidr_block     = "${aws_subnet.public.*.cidr_block[count.index]}"
  from_port      = 1024
  to_port        = 65535
}
