resource "google_recaptcha_enterprise_key" "primary" {
  display_name        = var.google_recaptcha_key_name
  project             = var.google_project_id
  web_settings {
    integration_type  = "SCORE"
    allowed_domains   = [var.project_hostname]
  }
}