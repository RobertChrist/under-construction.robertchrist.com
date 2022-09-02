resource "sumologic_cloudfront_source" "aws_cloudfront" {
  name                = "AWS CloudFront"
  description         = "Amazon CloudFront"
  category            = sumologic_collector.contact_form.name
  content_type        = "AwsCloudFrontBucket"
  scan_interval       = 60000
  cutoff_timestamp    = 1638680400000
  paused              = false
  collector_id        = sumologic_collector.contact_form.id

  authentication {
    type              = "AWSRoleBasedAuthentication"
    role_arn          = aws_iam_role.sumologic_cloudfront_s3bucket_role.arn
    region            = var.aws_s3bucket__cloudfront_log_bucket_region
  }

  path {
    type              = "S3BucketPathExpression"
    bucket_name       = var.aws_s3bucket__cloudfront_log_bucket_name
    path_expression   = "*.gz"
  }
}

resource "sumologic_http_source" "aws_cloudwatch_endpoint" {
  collector_id        = sumologic_collector.contact_form.id
  name                = "Cloudwatch Endpoint"
  category            = sumologic_collector.contact_form.name
}