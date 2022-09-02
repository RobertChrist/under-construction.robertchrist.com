resource "aws_api_gateway_usage_plan" "project_usage_plan" {
  name = "${var.project_name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.error.id
    stage  = aws_api_gateway_stage.contact_form.stage_name

    throttle {
      burst_limit = "200"
      path        = "*/*"
      rate_limit  = "100"
    }
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.contact_form.id
    stage  = aws_api_gateway_stage.error.stage_name

    throttle {
      burst_limit = "200"
      path        = "*/*"
      rate_limit  = "100"
    }
  }

  quota_settings {
    limit  = "5000"
    offset = "0"
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = "200"
    rate_limit  = "100"
  }
}