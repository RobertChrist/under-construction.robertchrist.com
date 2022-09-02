terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
    google = {
      version = "~> 4.12.0"
    }
    googleworkspace = {
      version = "~> 0.6.0"
    }
  }
}