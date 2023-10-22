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

variable "google_project_id" {
  type        = string
  description = "The id of the google project terraform should connect to."
  nullable    = false
}

variable "google_recaptcha_key_name" {
  type        = string
  description = "The name of the google recaptcha key."
  nullable    = false
}