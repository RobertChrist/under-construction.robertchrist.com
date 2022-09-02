resource "aws_route53_zone" "project_hosted_zone" {
  force_destroy = "false"
  name          = var.project_hostname
}