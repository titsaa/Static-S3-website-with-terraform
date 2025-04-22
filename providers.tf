terraform {
  # required_version = ">1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.94.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "student"
  region  = "us-east-1"
}

