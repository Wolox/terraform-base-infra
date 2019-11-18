# GCP 

## Setup

A terraform admin project must be created to handle all project creation and deployments. Setup `createTerraformAdminProject.sh` variables and run it to create it. Remember that you need `gcloud` installed and setup too.

Every environment requires a diferent project to be created. Billing account and organization id is also required to be set to deploy the resources.

![](diagram.png)

## Usage example

### Compute engine intance
```hcl
provider "google" {
  credentials = "${file("service-account.json")}"
  project     = "terraform-admin-project-name"
  region      = "us-west1"
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

### App Engine + Redis

Creates a project, a redis instance, and enables app engine.

```hcl
module "production" {
  source = "./gae_rds"

  project_name    = "prod-test-project"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
  project_owners  = ["user:user@wolox.com.ar"]
  project_editors = ["user:an.editor@wolox.com.ar"]

  rds_memory_size_gb = 2
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