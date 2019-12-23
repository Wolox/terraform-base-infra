## Usage example

```hcl
provider "aws" {
  profile = "eb-cli"
  region  = "us-east-1"
}

# Create the beanstalk app
module "app" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticbeanstalk/application"
  application = "test-app"
}

# Create the environment
module "env" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0"                    # Mandatory. Please, don't use this default.

  rds_db_name         = "development"       # Mandatory
  rds_username        = "testdb"            # Mandatory
  rds_password        = "unPassword!1234"   # Mandatory
  rds_engine          = "postgres"          # Optional
  rds_engine_version  = "11.4"             # Optional
  rds_port            = "5432"              # Optional
  rds_multi_az        = false               # Optional
  rds_instance_type   = "db.t2.micro"       # Optional

  eb_application         = "test-app"       # Mandatory
  eb_environment         = "development"    # Mandatory
  eb_ec2_key_name        = "somecustomkey"  # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance" # Optional
  eb_instance_type       = "t2.micro"       # Optional
  eb_stream_logs         = "true"           # Optional
  eb_solution_stack_name = "64bit Amazon Linux 2018.03 v2.12.17 running Docker 18.06.1-ce" # Optional
}

# Create the redis cluster
module "cache" {
  source                    = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticache"
  application               = "test-app"
  environment               = "development"
  azs                       = ["us-east-1a", "us-east-1b"]
  app_security_group        = "${module.env.servers_sg_id}"
  vpc_id                    = "${module.env.vpc_id}"
  server_public_subnet_cidr = "${module.env.public_subnets}"
  port                      = "6379" # Optional
  version                   = "4.0.10"
}

```
