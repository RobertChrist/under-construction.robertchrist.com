resource "aws_sns_topic_subscription" "contact_request__lambda" {
  endpoint             = aws_lambda_function.snslistener_contactform_emailer.arn
  protocol             = "lambda"
  raw_message_delivery = "false"
  topic_arn            = aws_sns_topic.contact_request.arn
}

resource "aws_sns_topic_subscription" "contact_request__sms" {
  endpoint             = var.phone_number_to_sms_on_contact_request
  protocol             = "sms"
  raw_message_delivery = "false"
  topic_arn            = aws_sns_topic.contact_request.arn
}

resource "aws_sns_topic_subscription" "contact_request__email" {
  endpoint             = var.email_address_to_message_on_contact_request
  protocol             = "email"
  topic_arn            = aws_sns_topic.contact_request.arn
}

resource "aws_sns_topic_subscription" "on_error__sms" {
  endpoint             = var.phone_number_to_sms_on_contact_request
  protocol             = "sms"
  raw_message_delivery = "false"
  topic_arn            = aws_sns_topic.on_error.arn
}

resource "aws_sns_topic_subscription" "on_error__email" {
  endpoint             = var.email_address_to_message_on_contact_request
  protocol             = "email"
  topic_arn            = aws_sns_topic.on_error.arn
}