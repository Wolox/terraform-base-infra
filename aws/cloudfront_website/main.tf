locals {
  origin_id          = "S3-Website-${module.bucket.bucket_website_endpoint}"
  custom_certificate = "${var.cf_certificate_domain == "" ? false : true}"
}

module "bucket" {
  source = "../s3/website"

  bucket_name          = "${var.bucket_name}"
  index_document       = "${var.bucket_index_document}"
  error_document       = "${var.bucket_error_document}"
  bucket_custom_domain = "${var.bucket_custom_domain}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${module.bucket.bucket_website_endpoint}"
    origin_id   = "${local.origin_id}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
  }

  enabled             = "${var.cf_enabled}"
  is_ipv6_enabled     = true
  default_root_object = "${var.bucket_index_document}"

  aliases = ["${var.cf_aliases}"]

  default_cache_behavior {
    allowed_methods  = ["${var.cf_allowed_methods}"]
    cached_methods   = ["${var.cf_cached_methods}"]
    target_origin_id = "${local.origin_id}"

    forwarded_values {
      query_string = "${var.cf_forward_query_string}"

      cookies {
        forward = "${var.cf_forward_cookies}"
      }
    }

    viewer_protocol_policy = "${var.cf_viewer_protocol_policy}"
    min_ttl                = "${var.cf_min_ttl}"
    default_ttl            = "${var.cf_default_ttl}"
    max_ttl                = "${var.cf_max_ttl}"
    compress               = "${var.cf_compress}"
  }

  viewer_certificate {
    cloudfront_default_certificate = "${!local.custom_certificate}"

    acm_certificate_arn      = "${local.custom_certificate ? element(concat(data.aws_acm_certificate.c.*.arn, list("")), 0) : ""}"
    minimum_protocol_version = "${local.custom_certificate ? "TLSv1.1_2016" : "TLSv1"}"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
