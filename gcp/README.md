# GCP 

## Usage example

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