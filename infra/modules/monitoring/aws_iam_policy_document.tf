data "aws_iam_policy_document" "sumologic__cloudfront_s3bucket_role" {
  statement {
    actions         = ["sts:AssumeRole"]
    effect          = "Allow"
    condition {
      test          = "StringEquals"
      variable      = "sts:ExternalId"

      values        = ["${var.sumologic_deployment_location}:${var.sumologic_account_id}"]
    }
    principals {
        type        = "AWS"
        # This is the official sumologic AWS account Id
        # https://help.sumologic.com/03Send-Data/Sources/02Sources-for-Hosted-Collectors/Amazon-Web-Services/Grant-Access-to-an-AWS-Product
        identifiers = ["arn:aws:iam::926226587429:root"]        
      }
    sid             = ""
  }
}

data "aws_iam_policy_document" "sumologic__cloudfront_allow_s3bucket_access" {
  statement {
    actions   = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:ListBucket"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::${var.aws_s3bucket__cloudfront_log_bucket_name}/*",
      "arn:aws:s3:::${var.aws_s3bucket__cloudfront_log_bucket_name}"
    ]
  }
}