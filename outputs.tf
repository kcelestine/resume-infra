output "website_endpoint" {
  value = data.aws_s3_bucket.selected-bucket.website_endpoint
}
