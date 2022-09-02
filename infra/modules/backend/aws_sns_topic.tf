resource "aws_sns_topic" "contact_request" {
  name                                     = "ContactRequest"
  application_success_feedback_sample_rate = "0"
  content_based_deduplication              = "false"
  fifo_topic                               = "false"
  firehose_success_feedback_sample_rate    = "0"
  http_success_feedback_sample_rate        = "0"
  lambda_success_feedback_sample_rate      = "0"
  sqs_success_feedback_sample_rate         = "0"
}

resource "aws_sns_topic" "on_error" {
  name                                     = "OnError"
  application_success_feedback_sample_rate = "0"
  content_based_deduplication              = "false"
  fifo_topic                               = "false"
  firehose_success_feedback_sample_rate    = "0"
  http_success_feedback_sample_rate        = "0"
  lambda_success_feedback_sample_rate      = "0"
  sqs_success_feedback_sample_rate         = "0"
}