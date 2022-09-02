output "aws_api_gateway_required_header_key_value" {
  value       = "${aws_api_gateway_api_key.project_key.value}"
}

output "log_group_name__api_gateway_contact_form" {
  value       = regex("/aws/apigateway/.*", aws_api_gateway_stage.contact_form.access_log_settings[0].destination_arn)
}

output "log_group_name__api_gateway_error_submission" {
  value       = regex("/aws/apigateway/.*", aws_api_gateway_stage.error.access_log_settings[0].destination_arn)
}

output "lambda__contact_emailer__name" {
  value = aws_lambda_function.snslistener_contactform_emailer.function_name
}

output "api_gateway__contact_request__api_id_slash_stage_name" {
  value = "${aws_api_gateway_rest_api.contact_form.id}/${aws_api_gateway_stage.contact_form.stage_name}"
}

output "api_gateway__error_submission__api_id_slash_stage_name" {
  value = "${aws_api_gateway_rest_api.error.id}/${aws_api_gateway_stage.error.stage_name}"
}

output "aws_iam_role__lambda__log_to_cloudwatch_arn" {
  value = aws_iam_role.lambda__log_to_cloudwatch_role.arn
}