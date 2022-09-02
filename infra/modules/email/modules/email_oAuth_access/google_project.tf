data "google_billing_account" "acct" {
  display_name = "My Billing Account"
  open         = true
}

data "google_organization" "org" {
  organization = var.google_organization_id
}

resource "google_project" "contact_form_gmail_response_account" {
  name                = var.google_project_name
  project_id          = var.google_project_id
  billing_account     = data.google_billing_account.acct.id
  org_id              = data.google_organization.org.org_id
}