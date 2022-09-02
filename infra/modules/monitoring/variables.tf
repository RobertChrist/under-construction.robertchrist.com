variable "project_name" {
  type        = string
  description = "The name of the project."
  nullable    = false
}

variable "sumologic_deployment_location" {
  type            = string
  description     = "this is probably us2.  Click here for more details: https://help.sumologic.com/APIs/General-API-Information/Sumo-Logic-Endpoints-by-Deployment-and-Firewall-Security"
  nullable        = false
}

variable "sumologic_account_id" {
  type            = string
  description     = "This is your personal sumologic account id.  It can be found via Administration > Account > Account Overview."
  nullable        = false
}

variable "aws_s3bucket__cloudfront_log_bucket_name" {
  type            = string
  description     = "The name of the bucket into which the cloudfront distribution for the website logs."
  nullable        = false
}

variable "aws_s3bucket__cloudfront_log_bucket_region" {
  type            = string
  description     = "The aws region in which the logging bucket is located"
  nullable        = false
}

variable "email_address_to_alert_on_sumologic_ingest_failure" {
  type        = string
  description = "If the SumoLogic CloudWatch Log Ingestion pipeline fails, what email address should be notified?"
  nullable    = false
}

variable "aws_account_id" {
  type        = number
  description = "Aws Account ID number"
  nullable    = false
}

variable "log_group_name__api_gateway_contact_form" {
  type        = string
  description = "The name of the log group for API Gateway Access Logs for the Contact Form API Gateway endpoint."
  nullable    = false
}

variable "log_group_name__api_gateway_error_submission" {
  type        = string
  description = "The name of the log group for API Gateway Access Logs for the Error Submission API Gateway endpoint."
  nullable    = false
}

variable "lambda__integration_tester__name" {
  type        = string
  description = "The name of the integration test lambda.  This will be used to discover the lambda's CloudWatch log group."
  nullable    = false
}

variable "lambda__contact_emailer__name" {
  type        = string
  description = "The name of the contact emailer lambda.  This will be used to discover the lambda's CloudWatch log group."
  nullable    = false
}

variable "api_gateway__contact_request__api_id_slash_stage_name" {
  type        = string
  description = "The name of the log group for API Gateway Execution Logs for the Contact Request endpoint's Production Stage."
  nullable    = false
}

variable "api_gateway__error_submission__api_id_slash_stage_name" {
  type        = string
  description = "The name of the log group for API Gateway Execution Logs for the Error Sumission endpoint's Production Stage."
  nullable    = false
}

variable "aws_region" {
  type        = string
  description = "The region in which the all aws components should bes located."
  nullable    = false
}