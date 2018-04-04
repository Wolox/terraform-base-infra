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

  aws_region = "eu-west-1"
  aws_azs    = ["eu-west-1a", "eu-west-1b"]

  ssh_cidr = "0.0.0.0/0"

  rds_db_name  = "development"
  rds_username = "joseperezuser"
  rds_password = "unPassword!1234"

  eb_application         = "test-app"
  eb_environment         = "development"
  eb_ec2_key_name        = "TestTerraform"
  eb_solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
  eb_environment_type    = "SingleInstance"
  eb_instance_type       = "t2.small"
}
```
