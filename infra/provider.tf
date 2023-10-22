terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22.0"
    }
    google = {
      version = "~> 4.12.0"
    }
    googleworkspace = {
      version = "~> 0.6.0"
    }
    sumologic = {
      source  = "sumologic/sumologic"
      version = "~>2.13.0"
    }
  }

  backend "local" {
    path = "../secrets/under-construction/infra/terraform.tfstate"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
  default_tags {
    tags = {
      Terraform = var.project_name
    }
  }
}

provider "google" {
  project = var.google_project_id
  # credentials = "it is recommended to use a service account json key pair."
}

provider "googleworkspace" {
  credentials             = "../secrets/under-construction/infra/google-workspace-service-account-keys.json"
  customer_id             = var.google_workspace_customer_id
  impersonated_user_email = var.google_workspace_impersonated_user
  oauth_scopes            = ["https://www.googleapis.com/auth/admin.directory.user", "https://www.googleapis.com/auth/admin.directory.group", "https://www.googleapis.com/auth/admin.directory.domain"]
}

provider "sumologic" {
  access_id   = var.sumologic_access_id
  access_key  = var.sumologic_access_key
  environment = "us2"
}