data "aws_acm_certificate" "c" {
  count  = "${var.bucket_custom_domain == "" ? 0 : 1}"
  domain = "${var.cf_certificate_domain}"
}

# Bucket variables
variable "bucket_name" {}

variable "bucket_index_document" {
  default = "index.html"
}

variable "bucket_error_document" {
  default = "index.html"
}

variable "bucket_custom_domain" {
  default = ""
}

# Cloudfront variables
variable "cf_certificate_domain" {
  default = ""
}

variable "cf_enabled" {
  default = true
}

variable "cf_aliases" {
  default = []
}

variable "cf_allowed_methods" {
  default = ["GET", "HEAD"]
}

variable "cf_cached_methods" {
  default = ["GET", "HEAD"]
}

variable "cf_forward_query_string" {
  default = true
}

variable "cf_forward_cookies" {
  default = "none"
}

variable "cf_viewer_protocol_policy" {
  default = "redirect-to-https"
}

variable "cf_min_ttl" {
  default = 0
}

variable "cf_default_ttl" {
  default = 86400
}

variable "cf_max_ttl" {
  default = 31536000
}

variable "cf_compress" {
  default = true
}
