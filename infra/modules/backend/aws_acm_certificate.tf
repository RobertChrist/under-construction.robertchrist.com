resource "aws_acm_certificate" "api_cert" {
  domain_name = "api.${var.project_hostname}"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  validation_method         = "EMAIL"
}