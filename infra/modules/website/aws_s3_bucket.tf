# under-construction.robertchrist.com is hosted out of an aws s3 bucket fronted by a CloudFront distribution.

resource "aws_s3_bucket" "primary_bucket" {
  arn            = "arn:aws:s3:::${var.project_name}"
  bucket         = var.project_name
  force_destroy  = "false"
  hosted_zone_id = "Z3AQBSTGFYJSTF"
}

resource "aws_s3_bucket_policy" "primary_bucket" {
  bucket = var.project_name

  # The bucket should only ever be accessed by CloudFront distributions.  CloudFront distributions will send
  # their requests containing a secret key, otherwise the request can be ignored.  See README for more information.
  policy = data.aws_iam_policy_document.s3__public_get_if_header_exists.json #templatefile("./modules/website/resource_files/s3_policy.tftpl", { s3_header_secret_key = var.s3_header_secret_key, project_name = var.project_name })
}

resource "aws_s3_bucket_website_configuration" "primary_bucket" {
  bucket = var.project_name
  index_document {
    suffix = "index.html"
  }
  routing_rule {
    condition {
      http_error_code_returned_equals = "403"
    }
    redirect {
      host_name        = var.project_hostname
      replace_key_with = ""
    }
  }
  routing_rule {
    condition {
      http_error_code_returned_equals = "404"
    }
    redirect {
      host_name        = var.project_hostname
      replace_key_with = ""
    }
  }
}

resource "aws_s3_bucket" "logs" {
  arn            = "arn:aws:s3:::logs.${var.project_name}"
  bucket         = "logs.${var.project_name}"
  force_destroy  = "false"
  hosted_zone_id = "Z3AQBSTGFYJSTF"
}