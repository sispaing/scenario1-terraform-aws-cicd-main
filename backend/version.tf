# Configure the Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
    shared_config_files      = ["/home/vagrant/.aws/config"]
    shared_credentials_files = ["/home/vagrant/.aws/credentials"]
    profile                  = "nickcloud-prod"
    region                   = var.aws_region
}