resource "aws_api_gateway_rest_api" "error" {
  api_key_source               = "HEADER"
  description                  = "Logs Errors"
  disable_execute_api_endpoint = "false"

  # Because api.${var.project_name} is an edge optimized custom domain, we don't
  # set the api itself as edge optimized.
  # https://stackoverflow.com/questions/49826230/regional-edge-optimized-api-gateway-vs-regional-edge-optimized-custom-domain-nam
  # Indeed, AWS suggests using a regional endpoint, as seen here:
  # https://aws.amazon.com/premiumsupport/knowledge-center/api-gateway-cloudfront-distribution/
  # see aws_route53_record.api for implementation.
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = "-1"
  name                     = "Error"
}


resource "aws_api_gateway_resource" "error" {
  parent_id   = ""
  path_part   = ""
  rest_api_id = aws_api_gateway_rest_api.error.id
}