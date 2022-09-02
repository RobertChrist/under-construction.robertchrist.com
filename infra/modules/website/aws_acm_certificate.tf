resource "aws_acm_certificate" "primary_cert" {
  domain_name = var.project_hostname

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  subject_alternative_names = ["www.${var.project_hostname}"]
  validation_method         = "EMAIL"
}