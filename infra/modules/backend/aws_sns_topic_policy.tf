resource "aws_sns_topic_policy" "contact_request" {
  arn = aws_sns_topic.contact_request.arn
  policy = data.aws_iam_policy_document.sns_topic__allow_publish_for_api_gateway_or_owner_account.json
}

resource "aws_sns_topic_policy" "on_error" {
  arn = aws_sns_topic.on_error.arn
  policy = data.aws_iam_policy_document.sns_topic__allow_publish_for_api_gateway_or_owner_account.json
}