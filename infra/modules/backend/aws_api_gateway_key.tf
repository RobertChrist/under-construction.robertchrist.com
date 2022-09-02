resource "aws_api_gateway_api_key" "project_key" {
  name              = "${var.project_name}-key"
  enabled           = true
}