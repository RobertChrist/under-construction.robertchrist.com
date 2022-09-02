data "aws_iam_policy_document" "s3__public_get_if_header_exists" {
  policy_id       = "${var.project_name} policy"
  statement {
    sid             = "Allow Cloudfront Access by Referer Header"
    actions       = ["s3:GetObject"]
    effect        = "Allow"
    resources     = ["${aws_s3_bucket.primary_bucket.arn}/*"]
    condition {
      test        = "StringLike"
      variable    = "aws:Referer"
      values      = [var.s3_header_secret_key]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    } 
  }
}