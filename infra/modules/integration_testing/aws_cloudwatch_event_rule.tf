resource "aws_cloudwatch_event_rule" "weekly_on_sunday" {
  description         = "${var.project_name} Weekly Lambda Integration Test"
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "WeeklyOnSunday"
  schedule_expression = "cron(0 17 ? * SUN *)"
}