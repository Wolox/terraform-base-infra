resource "aws_security_group" "cache_sg" {
  vpc_id = "${var.vpc_id}"
  name = "elasticache-${var.application}-${var.environment}-sg"

  ingress {
    from_port       = 6379
    to_port         = 6379
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
  name       = "pj-${substr(var.application, 0, 3)}-${substr(var.environment, 0, 5)}-sng"
  subnet_ids = ["${var.subnet_ids}"]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "pj-${substr(var.application, 0, 3)}-${substr(var.environment, 0, 5)}-cache"
  engine               = "redis"
  node_type            = "${var.node_type}"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  engine_version       = "4.0.10"
  port                 = 6379
  subnet_group_name    = "${aws_elasticache_subnet_group.subnet_group.name}"
  security_group_ids   = ["${aws_security_group.cache_sg.id}"]
}
