variable "project_name" {
  type        = string
  description = "The name of the project that requires an under-construction website.  Will also be the s3 bucket name."
  nullable    = false
}

variable "aws_iam_role__lambda__log_to_cloudwatch_arn" {
  type        = string
  description = "The aws_iam_role arn for lambda functions to allow logging to CloudWatch"
  nullable    = false
}

variable "lambda__cw_contact_form_integrationtester__source_code_hash" {
  type        = string
  description = "We track the source code hash of our lambdas in our secrets.auto.tfvars file, since we want to track what version is deployed to production, but shouldn't need to make a new commit in the code repository on each deploy."
  nullable    = false
}