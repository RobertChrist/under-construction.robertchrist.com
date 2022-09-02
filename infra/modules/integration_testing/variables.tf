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