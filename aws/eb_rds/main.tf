# Create the VPC and subnets
module "vpc" {
  source              = "../vpc"
  application         = "${var.eb_application}"
  environment         = "${var.eb_environment}"
  azs                 = "${var.aws_azs}"
  public_subnets      = "${var.public_subnets}"
  dbs_private_subnets = "${var.dbs_private_subnets}"
  ssh_cidr            = "${var.ssh_cidr}"
}
  
output "vpc_id" {
  value="${module.vpc.vpc_id}"
}

# Create the beanstalk environment
module "server" {
  source              = "../elasticbeanstalk/environment"
  application         = "${var.eb_application}"
  environment         = "${var.eb_environment}"
  vpc_id              = "${module.vpc.vpc_id}"
  subnets             = "${module.vpc.public_subnets}"
  security_group      = "${module.vpc.servers_sg_id}"
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
  security_group = "${module.vpc.dbs_sg_id}"
  multi_az       = "${var.rds_multi_az}"
  engine         = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"
}
