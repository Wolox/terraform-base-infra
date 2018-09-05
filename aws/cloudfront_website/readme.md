## Usage example

```hcl
rovider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "eu-west-1"
}

# Create the bucket with website configuration
module "website" {
  source = "git@github.com:Wolox/terraform-base-infra.git//aws/cloudfront_website"

  # Bucket variables
  bucket_name               = "test-bucket"       # Mandatory
  bucket_index_document     = "index.html"        # Optional
  bucket_error_document     = "index.html"        # Optional
  bucket_custom_domain      = ""                  # Optional, e.g. "mywebsite.wolox.com.ar"

  # CloudFront variables
  cf_certificate_domain     = ""                  # Optional, e.g. "*.wolox.com.ar"
  cf_enabled                = true                # Optional
  cf_aliases                = []                  # Optional, e.g. ["www.wolox.com.ar", "web.wolox.com.ar"]
  cf_allowed_methods        = ["GET", "HEAD"]     # Optional
  cf_cached_methods         = ["GET", "HEAD"]     # Optional
  cf_forward_query_string   = true                # Optional
  cf_forward_cookies        = "none"              # Optional, one of "all" or "none"
  cf_viewer_protocol_policy = "redirect-to-https" # Optional, one of "allow-all", "https-only" or "redirect-to-https"
  cf_min_ttl                = 0                   # Optional
  cf_default_ttl            = 86400               # Optional
  cf_max_ttl                = 31536000            # Optional
  cf_compress               = true                # Optional
}
```
