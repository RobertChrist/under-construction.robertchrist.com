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

variable "aws_region" {
  type        = string
  description = "The region in which the all aws components should bes located."
  nullable    = false
}

variable "aws_hosted_zone_id" {
  type        = string
  description = "We assume that api.project_name will be hosten in the same aws route 53 hosted zone as project_name itself.  So pass that value from the website/parent module in here"
  nullable    = false
}