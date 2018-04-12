## Usage example

```hcl
provider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "us-east-1"
}

# Create the bucket
module "bucket" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/s3/bucket"

  bucket_name = "test-bucket" # Mandatory
  policy      = ""            # Optional
  acl         = "public-read" # Optional. Allowed values (private, public-read, public-read-write,
                              #  aws-exec-read, authenticated-read, bucket-owner-read,
                              #  bucket-owner-full-control, log-delivery-write)
}
```
