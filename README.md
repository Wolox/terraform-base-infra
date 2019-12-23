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
  region  = "us-east-1"
}

data "aws_elastic_beanstalk_solution_stack" "docker_latest" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) running Docker (.*)$"
}

# Create the beanstalk app
module "app" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticbeanstalk/application"
  application = "test-app"
}

# Create the environment
module "development" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0"                    # Mandatory. Please, don't use this default.

  rds_db_name         = "development"       # Mandatory
  rds_username        = "joseperezuser"     # Mandatory
  rds_password        = "unPassword!1234"   # Mandatory
  rds_engine          = "postgres"          # Optional
  rds_engine_version  = "9.6.6"             # Optional
  rds_port            = "5432"              # Optional
  rds_multi_az        = false               # Optional
  rds_instance_type   = "db.t2.micro"       # Optional

  eb_application         = "test-app"       # Mandatory
  eb_environment         = "development"    # Mandatory
  eb_ec2_key_name        = "TestTerraform"  # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance" # Optional
  eb_instance_type       = "t3.small"       # Optional
  eb_stream_logs         = "false"          # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
}
```
If you ever need to add a new environment, `production` for example, just add a new module:

## Usage example

```hcl
provider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "us-east-1"
}

data "aws_elastic_beanstalk_solution_stack" "docker_latest" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) running Docker (.*)$"
}


# Create the beanstalk app
module "app" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/elasticbeanstalk/application"
  application = "test-app"
}

# Create development environment
module "development" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0"                    # Mandatory. Please, don't use this default.

  rds_db_name         = "development"       # Mandatory
  rds_username        = "joseperezuser"     # Mandatory
  rds_password        = "unPassword!1234"   # Mandatory
  rds_engine          = "postgres"          # Optional
  rds_engine_version  = "11.4"              # Optional
  rds_port            = "5432"              # Optional
  rds_multi_az        = false               # Optional
  rds_instance_type   = "db.t2.micro"       # Optional

  eb_application         = "test-app"       # Mandatory
  eb_environment         = "development"    # Mandatory
  eb_ec2_key_name        = "TestTerraform"  # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance" # Optional
  eb_instance_type       = "t3.small"       # Optional
  eb_stream_logs         = "false"          # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
}

module "production" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0"                    # Mandatory. Please, don't use this default.

  rds_db_name         = "development"       # Mandatory
  rds_username        = "joseperezuser"     # Mandatory
  rds_password        = "unPassword!1234"   # Mandatory
  rds_engine          = "postgres"          # Optional
  rds_engine_version  = "9.6.6"             # Optional
  rds_port            = "5432"              # Optional
  rds_multi_az        = false               # Optional
  rds_instance_type   = "db.t2.micro"       # Optional

  eb_application         = "test-app"       # Mandatory
  eb_environment         = "production"     # Mandatory
  eb_ec2_key_name        = "TestTerraform"  # Mandatory. Must exist in the account
  eb_environment_type    = "LoadBalanced"   # Optional
  eb_instance_type       = "t3.small"       # Optional
  eb_stream_logs         = "true"           # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
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
