# GCP 

## Setup

A terraform admin project must be created to handle all project creation and deployments. Setup `createTerraformAdminProject.sh` variables and run it to create it. Remember that you need [`gcloud` installed and set up too.](https://cloud.google.com/sdk/docs/downloads-interactive)

Every environment requires a diferent project to be created. Billing account and organization id is also required to be set to deploy the resources.

![](diagram.png)

## Redis Deploy FAQ

More info [here](RAILS_DEPLOY_FAQ.md).

## Usage example

### Compute engine intance
```hcl
provider "google" {
  credentials = "${file("service-account.json")}"
  project     = "terraform-admin-project-name"
  region      = "us-east1"
}

module "development" {
  source = "./project"

  project_name    = "dev-test-project"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
  owners          = ["user:some@mail.com"]
  editors         = ["user:one@mail.com", "user:another@mail.com"]
}

module "dev_compute" {
  source     = "./compute"
  project_id = "${module.development.project_id}"
}
```

### App Engine + Redis + Postgres

Creates a project, a redis instance, a postgres instance (with a user/password and database), enables app engine, and a Serverless VPC connection to connect app engine with cloud sql via private ip.

```hcl
variable "billing_account" {
  default = "12234-123445-12345"
}

variable "org_id" {
  default = "1234565789"
}

provider "google-beta" {
  credentials = "${file("~/.config/gcloud/terraform-admin-1234565789.json")}"
  region      = "us-east1"
  zone        = "us-east1-a"
}

provider "google" {
  credentials = "${file("~/.config/gcloud/terraform-admin-1234565789.json")}"
  region      = "us-east1"
  zone        = "us-east1-a"
}

module "production" {
  source = "./gae_rds"

  project_name       = "test-gae-sql4"
  billing_account    = "${var.billing_account}"
  org_id             = "${var.org_id}"
  project_owners     = ["user:wolox.user@wolox.com.ar"]
  project_editors    = ["user:wolox.user@wolox.com.ar"]
  region             = "us-east1"
  zone               = "us-east1-a"
  rds_zone           = "us-east1-b"
  rds_memory_size_gb = 1
  db_username      = "a_user"
  db_password      = "a_password"
  db_database_name = "a_database_name"
}
```

### Basic Cloud Run

Creates a project, enables cloud run & deploys a simple container.

```hcl
module "development" {
  source = "./project"

  project_name    = "dev-we-wolox"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
  owners          = ["user:federico.casares@wolox.com.ar", "user:matias.desanti@wolox.com.ar"]
  editors         = ["user:federico.casares@wolox.com.ar", "user:matias.desanti@wolox.com.ar"]
}

module "dev_cloudrun" {
  source     = "./cloudrun"
  project_id = "${module.development.project_id}"
}
```