# Create a security group for the beanstalk server
resource "aws_security_group" "beanstalk" {
  name   = "${var.eb_application}-${var.eb_environment}-server-sg"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${module.vpc.public_subnets_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for the database and allow access from beanstalk server
resource "aws_security_group" "rds" {
  name   = "${var.eb_application}-db-sg"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port       = "${var.rds_port}"
    to_port         = "${var.rds_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.beanstalk.id}"]
  }

  egress {
    from_port       = "${var.rds_port}"
    to_port         = "${var.rds_port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.beanstalk.id}"]
  }
}

# Create the VPC and subnets
module "vpc" {
  source              = "../vpc"
  application         = "${var.eb_application}"
  environment         = "${var.eb_environment}"
  azs                 = "${var.aws_azs}"
  public_subnets      = "${var.public_subnets}"
  dbs_private_subnets = "${var.dbs_private_subnets}"
}

# Create the beanstalk app
module "app" {
  source      = "../elasticbeanstalk/application"
  application = "${var.eb_application}"
}

# Create the beanstalk environment
module "server" {
  source              = "../elasticbeanstalk/environment"
  application         = "${var.eb_application}"
  environment         = "${var.eb_environment}"
  vpc_id              = "${module.vpc.vpc_id}"
  subnets             = "${module.vpc.public_subnets}"
  security_group      = "${aws_security_group.beanstalk.id}"
  ec2_key_name        = "${var.eb_ec2_key_name}"
  rds_connection_url  = "${var.rds_engine}://${var.rds_username}:${var.rds_password}@${module.db.endpoint}/${module.db.name}"
  solution_stack_name = "${var.eb_solution_stack_name}"
  environment_type    = "${var.eb_environment_type}"
  instance_type       = "${var.eb_instance_type}"
}

# Create the database
module "db" {
  source         = "../rds"
  azs            = "${var.aws_azs}"
  application    = "${var.eb_application}"
  environment    = "${var.eb_environment}"
  subnets        = "${module.vpc.private_dbs_subnets}"
  username       = "${var.rds_username}"
  password       = "${var.rds_password}"
  db_name        = "${var.rds_db_name}"
  security_group = "${aws_security_group.rds.id}"
  multi_az       = "${var.rds_multi_az}"
  engine         = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"
}
