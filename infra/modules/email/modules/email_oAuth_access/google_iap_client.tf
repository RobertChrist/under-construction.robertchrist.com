/*
This resource must be manually created and managed.  See README for more information.

resource "google_iap_client" "gmail_access_client" {
  brand        =  google_iap_brand.oAuth_consent_screen.name
  display_name = "Contact Form Email Handler AWS Lambda Client" 
}
*/