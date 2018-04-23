resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"

  force_destroy = true

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF

  website {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"

    routing_rules = <<EOF
[{
  "Condition": {
    "HttpErrorCodeReturnedEquals": "404"
  },
  "Redirect": {
    "HostName": "${var.bucket_custom_domain == "" ? local.default_website_url : var.bucket_custom_domain}",
    "ReplaceKeyPrefixWith": "#!/"
  }
}]
EOF
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["Authorization"]
    max_age_seconds = 3000
  }
}
