resource "aws_api_gateway_domain_name" "api" {
  certificate_arn = aws_acm_certificate.api_cert.arn
  domain_name     = aws_acm_certificate.api_cert.domain_name
}