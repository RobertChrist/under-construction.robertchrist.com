resource "aws_iam_role" "sumologic_cloudfront_s3bucket_role" {
  name                  = "sumologic_cloudfronts3bucket_role"

  assume_role_policy    = data.aws_iam_policy_document.sumologic__cloudfront_s3bucket_role.json
  managed_policy_arns   = [aws_iam_policy.sumologic__cloudfront_allow_s3bucket_access.arn]
  max_session_duration  = "3600"
  path                  = "/"
}