resource "aws_api_gateway_method" "error__preflight_options" {
  rest_api_id      = aws_api_gateway_rest_api.error.id
  resource_id      = aws_api_gateway_resource.error.id
  http_method      = "OPTIONS"

  api_key_required = "false"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "error__preflight_options" {
  rest_api_id      = aws_api_gateway_rest_api.error.id
  resource_id      = aws_api_gateway_resource.error.id
  http_method      = "OPTIONS"

  # OPTIONS calls are handled as a MOCK type.  See module readme for more information.
  type                 = "MOCK"
  timeout_milliseconds = "29000"

  cache_namespace      = aws_api_gateway_resource.error.id
  connection_type      = "INTERNET"
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "error__preflight_options" {
  rest_api_id      = aws_api_gateway_rest_api.error.id
  resource_id      = aws_api_gateway_resource.error.id
  http_method      = "OPTIONS"
  status_code      = "200"

  response_parameters = local.cors_response_parameters
  response_templates  = local.cors_response_template
}

resource "aws_api_gateway_method_response" "error__preflight_options" {
  rest_api_id      = aws_api_gateway_rest_api.error.id
  resource_id      = aws_api_gateway_resource.error.id
  http_method      = "OPTIONS"
  status_code      = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = local.cors_response_parameters_all_false
}