# terraform-base-infra

This repository contains the building blocks for basic infrastructure.

It inclues:

- ElasticBeanstaslk + RDS
- S3 Website

## ElasticBeanstalk + RDS

For a list of available soultion stack names please visit [this page](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html)

### Usage example

```hcl
provider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "eu-west-1"
}

# Create the beanstalk app
module "app" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticbeanstalk/application"
  application = "test-app"
}

# Create the environment
module "development" {
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
If you ever need to add a new environment, `production` for example, just add a new module:

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
module "development" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "eu-west-1"
  aws_azs    = ["eu-west-1a", "eu-west-1b"]

  ssh_cidr = "0.0.0.0/0"

  rds_db_name  = "myapp-development"
  rds_username = "joseperezuser"
  rds_password = "unPassword!1234"

  eb_application         = "${module.app.application_name}"
  eb_environment         = "development"
  eb_ec2_key_name        = "TestTerraform"
  eb_solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
  eb_environment_type    = "SingleInstance"
  eb_instance_type       = "t2.small"
}

module "production" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "eu-west-1"
  aws_azs    = ["eu-west-1a", "eu-west-1b"]

  ssh_cidr = "0.0.0.0/0"

  rds_db_name  = "myapp-production"
  rds_username = "joseperezuser"
  rds_password = "unPassword!1234"

  eb_application         = "${module.app.application_name}"
  eb_environment         = "production"
  eb_ec2_key_name        = "TestTerraform"
  eb_solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
  eb_environment_type    = "SingleInstance"
  eb_instance_type       = "t2.small"
}
```

## S3 Website

### Usage example

```hcl
provider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "eu-west-1"
}

# Create the bucket with website configuration
module "bucket" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/s3/website"

  bucket_name          = "test-bucket" # Mandatory
  index_document       = "index.html"  # Optional
  error_document       = "index.html"  # Optional
  bucket_custom_domain = ""            # Optional. For example 'mywebsite.wolox.com.ar'
}
```
