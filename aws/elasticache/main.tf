# Cache private subnets
resource "aws_subnet" "private_cache" {
  count                 = "${length(var.azs)}"
  vpc_id                = var.vpc_id
  cidr_block            = "${var.cache_private_subnets[count.index]}"
  cache_private_subnets = var.cache_private_subnets
  availability_zone     = "${var.azs[count.index]}"

  tags  = {
    Name = "${var.application}-${var.environment}-private-cache-${count.index}"
  }
}

# NACL for cache subnets
resource "aws_network_acl" "private_cache_acl" {
  vpc_id     = var.vpc_id
  subnet_ids = ["${aws_subnet.private_cache.*.id}"]

  tags  = {
    Name = "private-cache-subnet"
  }
}

resource "aws_network_acl_rule" "private_cache_public_acl_ingress" {
  network_acl_id = "${aws_network_acl.private_cache_acl.id}"
  egress         = false
  count          = "${length(var.azs)}"
  protocol       = "tcp"
  rule_number    = "12${count.index}"
  rule_action    = "allow"
  cidr_block     = "${var.server_public_subnet_cidr[count.index]}"
  from_port      = var.port
  to_port        = var.port
}

resource "aws_network_acl_rule" "private_cache_public_return_traffic" {
  network_acl_id = "${aws_network_acl.private_cache_acl.id}"
  egress         = true
  count          = "${length(var.azs)}"
  protocol       = "tcp"
  rule_number    = "13${count.index}"
  rule_action    = "allow"
  cidr_block     = "${var.server_public_subnet_cidr[count.index]}"
  from_port      = 1024
  to_port        = 65535
}


resource "aws_security_group" "cache_sg" {
  vpc_id = var.vpc_id
  name = "elasticache-${var.application}-${var.environment}-sg"

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = ["${var.app_security_group}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "${substr(var.application, 0, 3)}-${substr(var.environment, 0, 5)}-sng"
  subnet_ids = ["${aws_subnet.private_cache.*.id}"]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${substr(var.application, 0, 3)}-${substr(var.environment, 0, 5)}-cache"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  engine_version       = var.version_eng
  port                 = var.port
  subnet_group_name    = "${aws_elasticache_subnet_group.subnet_group.name}"
  security_group_ids   = ["${aws_security_group.cache_sg.id}"]
}
