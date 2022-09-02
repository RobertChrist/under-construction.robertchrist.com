resource "google_project_service" "gmail_api_access" {
  project = google_project.contact_form_gmail_response_account.project_id
  service = "gmail.googleapis.com"
}

# This service isn't required if you create the client credentials via the UI, 
# but is if you manage consent screens and client Ids via Terraform.
resource "google_project_service" "iap_api_access" {
  project = google_project.contact_form_gmail_response_account.project_id
  service = "iap.googleapis.com"
}

# This service is required if you want to attempt to manage google workspace via terraform.
# Otherwise it can safely be removed.
resource "google_project_service" "admin_sdk_api_access" {
  project = google_project.contact_form_gmail_response_account.project_id
  service = "admin.googleapis.com"
}