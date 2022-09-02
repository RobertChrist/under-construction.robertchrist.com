resource "aws_route53_record" "AAAA" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_cloudfront_distribution.primary_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.primary_distribution.hosted_zone_id
  }

  name    = var.project_hostname
  type    = "AAAA"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}

resource "aws_route53_record" "AAAA_for_www" {
  alias {
    evaluate_target_health = "true"
    name                   = var.project_hostname
    zone_id                = aws_route53_zone.project_hosted_zone.zone_id
  }

  name    = "www.${var.project_hostname}"
  type    = "AAAA"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}

resource "aws_route53_record" "A" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_cloudfront_distribution.primary_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.primary_distribution.hosted_zone_id
  }

  name    = var.project_hostname
  type    = "A"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}

resource "aws_route53_record" "A_for_www" {
  alias {
    evaluate_target_health = "true"
    name                   = var.project_hostname
    zone_id                = aws_route53_zone.project_hosted_zone.zone_id
  }

  name    = "www.${var.project_hostname}"
  type    = "A"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}

resource "aws_route53_record" "NS" {
  name    = var.project_hostname
  records = ["ns-1119.awsdns-11.org.", "ns-843.awsdns-41.net.", "ns-1896.awsdns-45.co.uk.", "ns-487.awsdns-60.com."]
  ttl     = "172800"
  type    = "NS"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}

resource "aws_route53_record" "SOA" {
  name    = var.project_hostname
  records = ["ns-1896.awsdns-45.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl     = "900"
  type    = "SOA"
  zone_id = aws_route53_zone.project_hosted_zone.zone_id
}