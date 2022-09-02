module "email_custom_domain" {
  source = "./modules/email_custom_domain"
  project_hostname = var.project_hostname
  googleworkspace_provided_dkim_key = var.googleworkspace_provided_dkim_key
  googleworkspace_provided_verification_key = var.googleworkspace_provided_verification_key
  email_address_receive_dmarc_summaries = var.email_address_receive_dmarc_summaries

  # If the website is hosted at ABC.com, we want to send and receive emails from someAddress@ABC.com
  aws_hosted_zone_id = var.aws_hosted_zone_id
}

module "email_oAuth_access" {
  source = "./modules/email_oAuth_access"

  project_hostname = var.project_hostname
  google_organization_id = var.google_organization_id
  google_project_id = var.google_project_id
  google_project_name = var.google_project_name
  google_oAuth_support_email_address = var.google_oAuth_support_email_address
  google_oAuth_application_name =  var.google_oAuth_application_name
}