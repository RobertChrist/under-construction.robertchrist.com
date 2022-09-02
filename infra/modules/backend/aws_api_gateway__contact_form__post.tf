resource "aws_api_gateway_method" "contact_form__post" {
  rest_api_id      = aws_api_gateway_rest_api.contact_form.id
  resource_id      = aws_api_gateway_resource.contact_form.id
  http_method      = "POST"

  api_key_required = "true"
  authorization    = "NONE"

  request_models = {
    "application/json" = aws_api_gateway_model.contact_form__post.name
  }

  request_validator_id = aws_api_gateway_request_validator.contact_form__post.id
}

resource "aws_api_gateway_request_validator" "contact_form__post" {
  name                        = "Validate body"
  rest_api_id                 = aws_api_gateway_rest_api.contact_form.id
  validate_request_body       = true
  validate_request_parameters = false
}

resource "aws_api_gateway_integration" "contact_form__post" {
  rest_api_id      = aws_api_gateway_rest_api.contact_form.id
  resource_id      = aws_api_gateway_resource.contact_form.id
  http_method      = "POST"

  cache_namespace         = aws_api_gateway_resource.contact_form.id
  connection_type         = "INTERNET"
  credentials             = aws_iam_role.api_gateway__publish_to_sns_and_push_to_cloudwatch.arn
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"

  request_parameters = {
    "integration.request.header.integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = <<-EOT
      #set($context.requestOverride.querystring.TopicArn='${aws_sns_topic.contact_request.arn}')
      #set($context.requestOverride.querystring.Message=$input.body)
      EOT
  }

  timeout_milliseconds = "29000"
  type                 = "AWS"
  uri                  = "arn:aws:apigateway:${var.aws_region}:sns:action/Publish"
}

resource "aws_api_gateway_integration_response" "contact_form__post_200" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "200"
  selection_pattern   = "2\\d{2}"

  response_parameters = local.cors_response_parameters
  response_templates  = local.cors_response_template
}

resource "aws_api_gateway_integration_response" "contact_form__post_400" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "400"
  selection_pattern   = "4\\d{2}"

  response_parameters = local.cors_response_parameters
  response_templates  = local.cors_response_template
}

resource "aws_api_gateway_integration_response" "contact_form__post_500" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "500"
  selection_pattern   = "5\\d{2}"

  response_parameters = local.cors_response_parameters
  response_templates  = local.cors_response_template
}

resource "aws_api_gateway_method_response" "contact_form__post_200" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "200"

  response_parameters = local.cors_response_parameters_all_false
}

resource "aws_api_gateway_method_response" "contact_form__post_400" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "400"

  response_parameters = local.cors_response_parameters_all_false
}

resource "aws_api_gateway_method_response" "contact_form__post_500" {
  rest_api_id         = aws_api_gateway_rest_api.contact_form.id
  resource_id         = aws_api_gateway_resource.contact_form.id
  http_method         = "POST"
  status_code         = "500"

  response_parameters = local.cors_response_parameters_all_false
}