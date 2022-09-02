resource "aws_api_gateway_rest_api" "contact_form" {
  api_key_source               = "HEADER"
  description                  = "Contact-Form"
  disable_execute_api_endpoint = "false"

  # Edge optimized gateways run on worldwide CDN locations, then route traffic over AWS' internal network
  endpoint_configuration {
    types = ["EDGE"]
  }

  minimum_compression_size = "-1"
  name                     = "Contact-Form"
}

resource "aws_api_gateway_resource" "contact_form" {
  parent_id   = ""
  path_part   = ""
  rest_api_id = aws_api_gateway_rest_api.contact_form.id
}