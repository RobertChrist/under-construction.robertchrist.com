resource "aws_api_gateway_stage" "contact_form" {
  stage_name            = "Production"
  description           = "Production"
  rest_api_id           = aws_api_gateway_rest_api.contact_form.id
  deployment_id         = aws_api_gateway_deployment.contact_form__deployment.id

  cache_cluster_enabled = "false"
  cache_cluster_size    = "0.5"
  xray_tracing_enabled  = "false"
  
  access_log_settings {
    destination_arn = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/apigateway/contactrequest"
    format          = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
  }
}

resource "aws_api_gateway_stage" "error" {
  stage_name            = "Production"
  description           = "Production"
  rest_api_id           = aws_api_gateway_rest_api.error.id
  deployment_id         = aws_api_gateway_deployment.error__deployment.id

  cache_cluster_enabled = "false"
  cache_cluster_size    = "0.5"
  xray_tracing_enabled  = "false"

  access_log_settings {
    destination_arn = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/apigateway/error"
    format          = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
  }
}