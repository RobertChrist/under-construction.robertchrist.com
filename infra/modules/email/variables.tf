# For use by all
variable "project_hostname" {
  type        = string
  description = "The website hostname, without the www.  Just ABC.com"
  nullable    = false
}


# For use by modules/email_custom_domain
variable "aws_hosted_zone_id" {
  type        = string
  description = "The hosted zone id in aws for the domain which we are configuring for email."
  nullable    = false
}

variable "googleworkspace_provided_dkim_key" {
  type        = string
  description = "As part of setting up Google Workspace management of gmail for your domain, Workspace will provide you with a dkim key to set in your DNS records."
  nullable    = false
}

variable "googleworkspace_provided_verification_key" {
  type        = string
  description = "To prove to Google Workspace that you own the domain in question, you will have to set a DNS TXT record to a value provided by Google Workspace."
  nullable    = false
}

variable "email_address_receive_dmarc_summaries" {
  type        = string
  description = "The dmarc authentication protocol results in daily summary emails sent to the owner of the domain."
  nullable    = false
}

# For use by modules/email_oAuth_access
variable "google_project_id" {
  type        = string
  description = "The id of the google project terraform should connect to."
  nullable    = false
}

variable "google_project_name" {
  type        = string
  description = "The name of the google project terraform should connect to."
  nullable    = false
}

variable "google_organization_id" {
  type        = string
  description = "The organization id of the google project terraform should connect to."
  nullable    = false
}

variable "google_oAuth_support_email_address" {
  type        = string
  description = "When creating an oAuth consent screen, a support email must be supplied."
  nullable    = false
}

variable "google_oAuth_application_name" {
  type        = string
  description = "The name of the GCP project that allows access to the gmail account via oAuth."
  nullable    = false
}