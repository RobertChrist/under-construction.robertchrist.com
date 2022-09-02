resource "aws_route53_record" "A_api" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_api_gateway_domain_name.api.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.api.cloudfront_zone_id
  }

  name    = "api.${var.project_hostname}"
  type    = "A"
  zone_id = var.aws_hosted_zone_id
}