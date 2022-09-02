resource "aws_route53_record" "mx_record" {
  name    = var.project_hostname
  records = ["10 ALT4.ASPMX.L.GOOGLE.COM", "1 ASPMX.L.GOOGLE.COM", "5 ALT1.ASPMX.L.GOOGLE.COM", "10 ALT3.ASPMX.L.GOOGLE.COM", "5 ALT2.ASPMX.L.GOOGLE.COM"]
  ttl     = "3600"
  type    = "MX"
  zone_id = var.aws_hosted_zone_id
}

resource "aws_route53_record" "spf_and_google_required_domain_ownership_verification_record" {
  name    = var.project_hostname
  records = [var.googleworkspace_provided_verification_key, "v=spf1 include:_spf.google.com ~all"]
  ttl     = "300"
  type    = "TXT"
  zone_id = var.aws_hosted_zone_id
}

resource "aws_route53_record" "dkim_record" {
  name    = "google._domainkey.${var.project_hostname}"
  records = [var.googleworkspace_provided_dkim_key]
  ttl     = "300"
  type    = "TXT"
  zone_id = var.aws_hosted_zone_id
}

resource "aws_route53_record" "dmarc_record" {
  name    = "_dmarc.${var.project_hostname}"
  records = ["v=DMARC1; p=none; rua=mailto:${var.email_address_receive_dmarc_summaries}"]
  ttl     = "300"
  type    = "TXT"
  zone_id = var.aws_hosted_zone_id
}