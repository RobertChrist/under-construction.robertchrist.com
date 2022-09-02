variable "project_hostname" {
  type        = string
  description = "The website hostname, without the www.  Just ABC.com"
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