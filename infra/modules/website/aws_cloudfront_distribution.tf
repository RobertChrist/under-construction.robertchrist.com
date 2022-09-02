# Our dns name will point to our cloudfront distribution, which will stand in front of our s3 bucket.

resource "aws_cloudfront_distribution" "primary_distribution" {
  aliases = [var.project_hostname, "www.${var.project_hostname}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    compress               = "true"
    default_ttl            = "0"
    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "${var.project_name}.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"
  }

  default_root_object = "index.html"
  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"

  logging_config {
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    include_cookies = "false"
  }

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"

    # Our s3 bucket will ignore any requests that do not include our secret key for CloudFront distributions.
    # See bucket or README for more information.
    custom_header {
      name  = "Referer"
      value = var.s3_header_secret_key
    }

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1", "TLSv1.2"]
    }

    # Because we are using the s3 bucket in 'website endpoint' configuration, we must use 
    # the pattern http://bucket-name.s3-website-region.amazonaws.com, as described here 
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DownloadDistS3AndCustomOrigins.html
    domain_name = "${var.project_name}.s3-website-us-east-1.amazonaws.com"
    origin_id   = "${var.project_name}.s3.us-east-1.amazonaws.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.primary_cert.arn
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}