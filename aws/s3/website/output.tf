output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}

output "bucket_website_domain" {
  value = aws_s3_bucket.bucket.website_domain
}
