output "aws_api_gateway_required_header_key_value" {
  value     = module.backend.aws_api_gateway_required_header_key_value
  sensitive = true
}

output "aws_api_gateway_contact_request_model_definition" {
  value = "is available at module.backend.aws_api_gateway_model.contact_form__post.schema"
}