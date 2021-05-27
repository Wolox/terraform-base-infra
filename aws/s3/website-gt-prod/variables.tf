data "aws_region" "current" {}

variable "bucket_name" {}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "index.html"
}

variable "bucket_custom_domain" {
  default = ""
}

locals {
  default_website_url = "${var.bucket_name}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}
