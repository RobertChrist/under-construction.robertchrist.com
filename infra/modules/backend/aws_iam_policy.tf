resource "aws_iam_policy" "sns_publish__allow_publish" {
  name = "Sns__allow_publish"
  path = "/"

  policy = data.aws_iam_policy_document.sns_topic__allow_publish.json
}

data "aws_iam_policy" "api_gateway__allow_push_to_cloudwatch_logs" {
  arn           = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs" #AWS built-in available policy
}

resource "aws_iam_policy" "cloudwatch__allow_log_group_and_streams__for_lambda_log_groups" {
  name = "cloudwatch__allow_log_group_and_streams__for_lambda_log_groups"
  path = "/service-role/"

  policy = data.aws_iam_policy_document.cloudwatch__allow_log_group_and_streams__for_lambda_log_groups.json
}