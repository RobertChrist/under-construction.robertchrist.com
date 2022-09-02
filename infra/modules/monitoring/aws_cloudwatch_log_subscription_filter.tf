resource "aws_cloudwatch_log_subscription_filter" "api_gateway_contact_form" {
  name                = "no-filter"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = "\" \""
  log_group_name      = aws_cloudwatch_log_group.api_gateway_contact_form.name
}

resource "aws_cloudwatch_log_subscription_filter" "api_gateway_error" {
  name                = "no-filter"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = "\" \""
  log_group_name      = aws_cloudwatch_log_group.api_gateway_error_submission.name
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_integration_test" {
  name                = "SumoLogic stream for under-construction integration test"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = ""
  log_group_name      = aws_cloudwatch_log_group.lambda_integration_test.name
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_contact_emailer" {
  name                = "no-filter"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = "\" \""
  log_group_name      = aws_cloudwatch_log_group.lambda_contact_emailer.name
}

resource "aws_cloudwatch_log_subscription_filter" "api_gateway_contact_form_execution_logs" {
  name                = "no-filter"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = "\" \""
  log_group_name      = aws_cloudwatch_log_group.api_gateway_contact_form_execution_logs.name
}

resource "aws_cloudwatch_log_subscription_filter" "api_gateway_error_submission_execution_logs" {
  name                = "no-filter"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = "\" \""
  log_group_name      = aws_cloudwatch_log_group.api_gateway_error_submission_execution_logs.name
}

resource "aws_cloudwatch_log_subscription_filter" "sns_sms_direct_publish_failure_logs" {
  name                = "SumoLogic-Ingestor-Stack-SumoCWLogSubsriptionFilter-12345"
  destination_arn     = aws_cloudformation_stack.sumologic_ingestor_stack.outputs.SumoCWLogsLambdaArn
  filter_pattern      = ""
  log_group_name      = aws_cloudwatch_log_group.sns_sms_direct_publish_failure_logs.name
}