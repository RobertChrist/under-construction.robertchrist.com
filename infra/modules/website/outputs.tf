output "aws_route53_zone__project_hosted_zone__zone_id" {
  value = aws_route53_zone.project_hosted_zone.zone_id
}

output "aws_s3bucket__cloudfront_log_bucket_name" {
  value = aws_s3_bucket.logs.id
}

output "aws_s3bucket__cloudfront_log_bucket_region" {
  value = aws_s3_bucket.logs.region
}