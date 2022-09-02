resource "aws_sns_sms_preferences" "sms_preferences" {
  monthly_spend_limit = 10
  delivery_status_iam_role_arn = aws_iam_role.cloudwatch__sns_sms_success_logs.arn
  delivery_status_success_sampling_rate = 100
  default_sender_id = var.sms_from_contact_name
  default_sms_type  = "Transactional"
}