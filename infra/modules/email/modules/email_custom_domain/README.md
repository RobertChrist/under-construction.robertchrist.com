## Overview

This module is responsible for managing the configuration of our domain name, for use in sending
and receiving emails.  This will allow us to send and receive emails with addresses such as 
Contact@projectname.com or Reply-To@projectname.com.

In our current configuration, we manage our email domain via a google workspace account, and configure
it via dns records.

## Terraform Limitations - Manual Steps Required Outside of Terraform

* **Configure the Google Workspace Account to utilize the Custom Domain**
Configuring Google Workspace to manage email accounts at a custom domain name requires manual configuration.
That configuration consists almost entirely of setting DNS records, and then manually entering that information into the Google Workspace Admin website.
These DNS record values can then be tracked via Terraform via this module.

  See the following links for documentation.

  https://support.google.com/a/topic/9202?hl=en&ref_topic=9197
  https://support.google.com/a/answer/10583557?src=supportwidget0