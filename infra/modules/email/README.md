## Overview

This module is responsible for all configuration required to own an oAuth accessible gmail account on a custom domain name.  The domain name is configured to be the same domain name as defined in the [website module](../website).  GCP and Google Workspace are leveraged to meet these requirements.

## Purpose

Our website seeks to automatically send an email from a Contact@Project-Domain.com email address, whenever a user submits a contact form on the website.

To achieve this, we have created a Google Workspace account. We the grant this Google Workspace account the ability to mange email (gmail) at our privately owned (projectname.com) custom domain.

We then manage oAuth access to any email account managed by our Google Workspace account, via a Google Cloud project that is also associated with the Google Workspace account.

These oAuth tokens are then made available to the backend of our application to send and receive emails automatically, on behalf of email addresses at our custom domain.

## Architecture

**googleworkspace_domain** 
This file is responsible for ensuring the existence of a Google Workspace account associated to the custom domain.  See manual steps listed below.

**email_custom_domain module**
This module is responsible for managing all configuration required to allow gmail (via GoogleWorkspace) to send and receive emails from a privately owned domain.

See the README in this module for more information.

**email_oAuth_access module**
This module is responsible for managing all configuration required to configure oAuth access to a gmail account.

This is done by using a Google Cloud Project, that can create and distribute gmail oAuth client tokens for any email address managed by the Google Workspace account that is associated with this GCP project.

See the README in this module for more information.

## Terraform Limitations - Manual Steps Required Outside of Terraform

* **Creating a new Google Workspace account still requires manual steps.**
  To manually create a Google Workspace account, and manually associate it with your custom domain, please follow the steps [made available by Google here](
https://apps.google.com/supportwidget/articlehome?hl=en&article_url=https%3A%2F%2Fsupport.google.com%2Fa%2Fanswer%2F182080%3Fhl%3Den&product_context=182080&product_name=UnuFlow&trigger_context=a)

## Configuring the Google Workspace Terraform provider
Configuration steps are documented here, in the section ["Configuring the Provider"](https://www.hashicorp.com/blog/announcing-the-google-workspace-provider-for-hashicorp-terraform-tech-preview)