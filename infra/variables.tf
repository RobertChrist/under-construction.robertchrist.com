# for use by modules/website
variable "project_name" {
  type        = string
  description = "The name of the project that requires an under-construction website.  Will also be the s3 bucket name."
  nullable    = false
}

variable "project_hostname" {
  type        = string
  description = "The website hostname, without the www.  Just ABC.com"
  nullable    = false
}

variable "s3_header_secret_key" {
  type        = string
  description = "The hosting s3 bucket will only serve requests that contain this secret key in the header."
  nullable    = false
  validation {
    condition     = length(var.s3_header_secret_key) > 16
    error_message = "The s3_header_secret_key should be a guid or long string."
  }
}

variable "recaptcha_secret_key" {
  type        = string
  description = "The secret key for the recaptcha token, available at https://www.google.com/u/3/recaptcha/admin."
  nullable    = false
  validation {
    condition     = length(var.recaptcha_secret_key) > 16
    error_message = "The recaptcha secret key should be a long string."
  }
}

variable "google_recaptcha_key_name" {
  type        = string
  description = "The name of the google recaptcha key."
  nullable    = false
}

#for use by modules/email for email_custom_domain submodule
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


#For use by modules/email for email_oAuth_access
variable "google_organization_id" {
  type        = string
  description = "The organization id of the google project terraform should connect to."
  nullable    = false
}

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

# For use by GoogleWorkspace provider

variable "google_workspace_customer_id" {
  type        = string
  description = "Provided with your Google Workspace subscription and can be found in the admin console under Account Settings."
  nullable    = false
}

variable "google_workspace_impersonated_user" {
  type        = string
  description = "https://www.hashicorp.com/blog/announcing-the-google-workspace-provider-for-hashicorp-terraform-tech-preview"
  nullable    = false
}

# For use by backend
variable "aws_account_id" {
  type        = number
  description = "Aws Account ID number"
  nullable    = false
}

variable "phone_number_to_sms_on_contact_request" {
  type        = string
  description = "When a user submits a contact request, this phone number should receive an sms message."
  nullable    = false
}

variable "email_address_to_message_on_contact_request" {
  type        = string
  description = "When a user submits a contact request, this email address should receive an sms message."
  nullable    = false
}

variable "sms_from_contact_name" {
  type        = string
  description = "The default sender ID for AWS SNS SMS messages"
  nullable    = false
}

variable "aws_region" {
  type        = string
  description = "The region in which the all aws components should bes located."
  nullable    = false
}

variable "lambda__snslistener_contactform_emailer__source_code_hash" {
  type        = string
  description = "We track the source code hash of our lambdas in our secrets.auto.tfvars file, since we want to track what version is deployed to production, but shouldn't need to make a new commit in the code repository on each deploy."
  nullable    = false
}

# For use by monitoring
variable "sumologic_access_id" {
  type        = string
  description = "Sumo Logic Access ID"
  nullable    = false
}

variable "sumologic_access_key" {
  type        = string
  description = "Sumo Logic Access Key"
  sensitive   = true
  nullable    = false
}

variable "sumologic_account_id" {
  type        = string
  description = "This is your personal sumologic account id.  It can be found via Administration > Account > Account Overview."
  nullable    = false
}

variable "sumologic_deployment_location" {
  type        = string
  description = "this is probably us2.  Click here for more details: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-by-Deployment-and-Firewall-Security"
  nullable    = false
}

variable "email_address_to_alert_on_sumologic_ingest_failure" {
  type        = string
  description = "If the SumoLogic CloudWatch Log Ingestion pipeline fails, what email address should be notified?"
  nullable    = false
}

#For use by Integration Testing
variable "lambda__cw_contact_form_integrationtester__source_code_hash" {
  type        = string
  description = "We track the source code hash of our lambdas in our secrets.auto.tfvars file, since we want to track what version is deployed to production, but shouldn't need to make a new commit in the code repository on each deploy."
  nullable    = false
}