terraform {
  required_providers {
    sumologic = {
      source = "sumologic/sumologic"
      version = "~>2.13.0"
    }

  aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22.0"
    }
  }
}