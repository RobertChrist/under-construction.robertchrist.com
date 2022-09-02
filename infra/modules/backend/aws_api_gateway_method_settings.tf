resource "aws_api_gateway_method_settings" "contact_form_settings" {
  rest_api_id               = aws_api_gateway_rest_api.contact_form.id
  stage_name                = aws_api_gateway_stage.contact_form.stage_name
  method_path               = "*/*"
  settings {
    logging_level           = "INFO"     # API Execution Logging
    data_trace_enabled      = true
    metrics_enabled         = false
    throttling_burst_limit  = 5000
    throttling_rate_limit   = 10000
  }
}

resource "aws_api_gateway_method_settings" "error_settings" {
  rest_api_id               = aws_api_gateway_rest_api.error.id
  stage_name                = aws_api_gateway_stage.error.stage_name
  method_path               = "*/*"
  settings {
    logging_level           = "INFO"     # API Execution Logging
    data_trace_enabled      = true
    metrics_enabled         = false
    throttling_burst_limit  = 5000
    throttling_rate_limit   = 10000
  }
}