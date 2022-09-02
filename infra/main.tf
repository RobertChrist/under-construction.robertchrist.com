module "website" {
  source = "./modules/website"

  project_name         = var.project_name
  project_hostname     = var.project_hostname
  s3_header_secret_key = var.s3_header_secret_key

}

module "email" {
  source = "./modules/email"

  project_hostname                          = var.project_hostname
  googleworkspace_provided_dkim_key         = var.googleworkspace_provided_dkim_key
  googleworkspace_provided_verification_key = var.googleworkspace_provided_verification_key
  email_address_receive_dmarc_summaries     = var.email_address_receive_dmarc_summaries

  # If the website is hosted at ABC.com, we want to send and receive emails from someAddress@ABC.com
  aws_hosted_zone_id = module.website.aws_route53_zone__project_hosted_zone__zone_id

  google_organization_id             = var.google_organization_id
  google_project_id                  = var.google_project_id
  google_project_name                = var.google_project_name
  google_oAuth_support_email_address = var.google_oAuth_support_email_address
  google_oAuth_application_name      = var.google_oAuth_application_name
}

module "backend" {
  source = "./modules/backend"

  aws_account_id                              = var.aws_account_id
  phone_number_to_sms_on_contact_request      = var.phone_number_to_sms_on_contact_request
  email_address_to_message_on_contact_request = var.email_address_to_message_on_contact_request
  sms_from_contact_name                       = var.sms_from_contact_name
  project_name                                = var.project_name
  project_hostname                            = var.project_hostname
  aws_region                              	  = var.aws_region
  aws_hosted_zone_id                          = module.website.aws_route53_zone__project_hosted_zone__zone_id
}

module "integration_testing" {
  source = "./modules/integration_testing"

  project_name                                = var.project_name
  aws_iam_role__lambda__log_to_cloudwatch_arn = module.backend.aws_iam_role__lambda__log_to_cloudwatch_arn
}

module "monitoring" {
  source = "./modules/monitoring"

  sumologic_account_id          = var.sumologic_account_id
  sumologic_deployment_location = var.sumologic_deployment_location
  aws_account_id                = var.aws_account_id
  aws_region                	= var.aws_region

  project_name                                       = var.project_name
  aws_s3bucket__cloudfront_log_bucket_name           = module.website.aws_s3bucket__cloudfront_log_bucket_name
  aws_s3bucket__cloudfront_log_bucket_region         = module.website.aws_s3bucket__cloudfront_log_bucket_region
  email_address_to_alert_on_sumologic_ingest_failure = var.email_address_to_alert_on_sumologic_ingest_failure

  log_group_name__api_gateway_contact_form               = module.backend.log_group_name__api_gateway_contact_form
  log_group_name__api_gateway_error_submission           = module.backend.log_group_name__api_gateway_error_submission
  lambda__integration_tester__name                       = module.integration_testing.lambda__integration_tester__name
  lambda__contact_emailer__name                          = module.backend.lambda__contact_emailer__name
  api_gateway__contact_request__api_id_slash_stage_name  = module.backend.api_gateway__contact_request__api_id_slash_stage_name
  api_gateway__error_submission__api_id_slash_stage_name = module.backend.api_gateway__error_submission__api_id_slash_stage_name
}