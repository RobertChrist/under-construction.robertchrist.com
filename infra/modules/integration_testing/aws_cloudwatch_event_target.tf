resource "aws_cloudwatch_event_target" "lambda__cwevent_contactform_integrationtest" {
  rule      = aws_cloudwatch_event_rule.weekly_on_sunday.name
  arn       = aws_lambda_function.cwevent_contactform_integrationtester.arn
}