## Overview

This module is responsible for managing the GCP project which oversees oAuth access to our Google Workspace managed email accounts.

Unfortunately, limitations of the gCloud api (March 2022) mean that some things must still be managed and configured manually.  Please see below:

## Architecture
* **GCP Project**
A Google Cloud Project is configured within the Google Workspace account to handle the oAuth credential management.

* **Google Project Services**
Ensures the GCP project has IAP and Gmail API access.  Gmail for the oAuth credentials, IAP as a terraform dependency for managing oAuth credentials.

* **Google IAP Brands**
This is the terraform name for managing oAuth consent screens.  Some aspects of this management still must be done manually (there is no google api available), please see below.

* **Google IAP Clients**
This is the terraform name for managing gmail enabled oAuth credentials.  Management of this resource must be done manually in the Google Cloud Console (there is no google api available as of early 2022 compatible with our purposes).  Please see below.

## Terraform Limitations - Manual Steps Required Outside of Terraform

* **Creating and Managing Client IDs**
  google_iap_client is the data/resource block required to interact with a GCP oAuth client Id.
  However, google_iap_client does not allow for setting the redirect url of the client Ids it manages and creates.

  As a result, client Ids must be created manually via the GCP console (website).

  Unfortunately, if you create a client token/id manually, you will find that the google api does not allow programmatic management of manually created client ids, and attempting to terraform import google_iap_client or manage it via gcloud will result in error.

  As such, client ids for this application must be created and managed manually.  The most concise walk through of this process I have found is documented here: https://stackoverflow.com/questions/51933601/what-is-the-definitive-way-to-use-gmail-with-oauth-and-nodemailer

* **Publishing your oAuth Consent Screen**
  Tokens created for use with an unverified oAuth consent screen have a maximum timeout period of one week.
  As a result, you MUST publish your oAuth consent screen.  

  Since we are using a google workspace account to manage our email accounts via [../modules/email_custom_domain](../modules/email_custom_domain), we have chosen to publish our oAuth consent screen only to email addresses managed by this google workspace account, instead of publishing publicly.  This isn't strictly necessary, but is a bit cleaner.

  As such, this project requires that this GCP project is associated with the same google workspace account that manages our custom email accounts.

  **Manually publish your oAuth consent screen**
  There appears to be no way to do this via terraform.

  Simply go to the oAuth consent screen page in the APIs & services section of Google Cloud console, and click 'Publish to Internal.'

**Relevant links to above limitations.**
https://stackoverflow.com/questions/65270735/add-redirect-uri-to-automatically-generated-google-oauth-2-0-client-id
https://github.com/hashicorp/terraform-provider-google/issues/6482
https://github.com/hashicorp/terraform-provider-google/issues/6074
https://github.com/hashicorp/terraform-provider-google/issues/1287
https://stackoverflow.com/questions/67978438/how-can-i-deploy-a-gcp-api-credential-via-terraform
https://stackoverflow.com/questions/51549109/how-to-create-a-oauth-client-id-for-gcp-programmatically