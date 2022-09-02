resource "aws_cloudwatch_log_group" "api_gateway_contact_form" {
  name = var.log_group_name__api_gateway_contact_form
  retention_in_days     = 545
}

resource "aws_cloudwatch_log_group" "api_gateway_error_submission" {
  name = var.log_group_name__api_gateway_error_submission
  retention_in_days     = 545
}

resource "aws_cloudwatch_log_group" "lambda_integration_test" {
  name = "/aws/lambda/${var.lambda__integration_tester__name}"
  retention_in_days     = 545
}

resource "aws_cloudwatch_log_group" "lambda_contact_emailer" {
  name = "/aws/lambda/${var.lambda__contact_emailer__name}"
}

resource "aws_cloudwatch_log_group" "api_gateway_contact_form_execution_logs" {
  name = "API-Gateway-Execution-Logs_${var.api_gateway__contact_request__api_id_slash_stage_name}"
  retention_in_days     = 545
}

resource "aws_cloudwatch_log_group" "api_gateway_error_submission_execution_logs" {
 name = "API-Gateway-Execution-Logs_${var.api_gateway__error_submission__api_id_slash_stage_name}"
 retention_in_days     = 545
}

resource "aws_cloudwatch_log_group" "sns_sms_direct_publish_logs" {
  name = "sns/${var.aws_region}/${var.aws_account_id}/DirectPublishToPhoneNumber"
   retention_in_days     = 30
}

resource "aws_cloudwatch_log_group" "sns_sms_direct_publish_failure_logs" {
  name = "sns/${var.aws_region}/${var.aws_account_id}/DirectPublishToPhoneNumber/Failure"
   retention_in_days     = 30
}