resource "aws_api_gateway_usage_plan_key" "project_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.project_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.project_usage_plan.id
}