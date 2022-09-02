resource "aws_iam_policy" "sumologic__cloudfront_allow_s3bucket_access" {
  name = "sumologic_cloudfronts3bucket_access"
  path = "/"

  policy = data.aws_iam_policy_document.sumologic__cloudfront_allow_s3bucket_access.json
}