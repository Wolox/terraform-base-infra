## Usage example

```hcl
provider "aws" {
  profile = "eb-cli"
  region  = "eu-west-1"
}

# Create the beanstalk app
module "app" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticbeanstalk/application"
  application = "test-app"
}

# Create the environment
module "env" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "eu-west-1"                  # Mandatory
  aws_azs    = ["eu-west-1a", "eu-west-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0"                    # Mandatory

  rds_db_name         = "development"       # Mandatory
  rds_username        = "joseperezuser"     # Mandatory
  rds_password        = "unPassword!1234"   # Mandatory
  rds_engine"         = "postgres"          # Optional
  rds_engine_version" = "9.6.6"             # Optional
  rds_port"           = "5432"              # Optional
  rds_multi_az"       = false               # Optional
  rds_instance_type   = "db.t2.micro"       # Optional

  eb_application         = "test-app"       # Mandatory
  eb_environment         = "development"    # Mandatory
  eb_ec2_key_name        = "TestTerraform"  # Mandatory. Must exists in the account
  eb_environment_type    = "SingleInstance" # Optional
  eb_instance_type       = "t2.small"       # Optional
  eb_solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce" # Optional
g}
```



