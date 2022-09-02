resource "aws_iam_role" "api_gateway__push_to_cloudwatch" {
  name                 = "APIGateway_LogToCloudwatch"
  assume_role_policy = data.aws_iam_policy_document.api_gateway__assume_role.json

  description          = "Allows API Gateway to push logs to CloudWatch Logs."
  max_session_duration = "3600"
  path                 = "/"
}

resource "aws_iam_role_policy_attachment" "api_gateway__allow_push_to_cloudwatch_only" {
  policy_arn = data.aws_iam_policy.api_gateway__allow_push_to_cloudwatch_logs.arn
  role       = aws_iam_role.api_gateway__push_to_cloudwatch.name
}

/* -------------- */

resource "aws_iam_role" "api_gateway__publish_to_sns_and_push_to_cloudwatch" {
  name                 = "APIGateway_PublishToSNS_PushToCloudwatch_Role"
  assume_role_policy   = data.aws_iam_policy_document.api_gateway__assume_role.json
  description          = "Allows API Gateway to publish to sns and push to cloudwatch."
  max_session_duration = "3600"
  path                 = "/"
}

resource "aws_iam_role_policy_attachment" "api_gateway__allow_publish_to_sns" {
  role       = aws_iam_role.api_gateway__publish_to_sns_and_push_to_cloudwatch.name
  policy_arn = aws_iam_policy.sns_publish__allow_publish.arn
}

resource "aws_iam_role_policy_attachment" "api_gateway__allow_push_to_cloudwatch" {
  role       = aws_iam_role.api_gateway__publish_to_sns_and_push_to_cloudwatch.name
  policy_arn = data.aws_iam_policy.api_gateway__allow_push_to_cloudwatch_logs.arn
}

/* -------------- */

resource "aws_iam_role" "lambda__log_to_cloudwatch_role" {
  name                 = "lambda__snslistener_contactform_emailer_role"
  assume_role_policy   = data.aws_iam_policy_document.lambda__assume_role.json
  path                 = "/service-role/"
  max_session_duration = "3600"
}

resource "aws_iam_role_policy_attachment" "lambda__log_to_cloudwatch" {
  role       = aws_iam_role.lambda__log_to_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch__allow_log_group_and_streams__for_lambda_log_groups.arn
}


/* -------------- */

resource "aws_iam_role" "cloudwatch__sns_sms_success_logs" {
  name                 = "cloudwatch__sns_sms_success_logs"
  assume_role_policy   = data.aws_iam_policy_document.sns__assume_role.json
  path                 = "/"
  max_session_duration = "3600"
  inline_policy {
    name = "cloudwatch__sns_sms_success_logs"

    policy = data.aws_iam_policy_document.cloudwatch__sns_sms_success_logs.json
  }
}