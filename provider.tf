terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.18"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = var.provider_block.mu
  access_key = var.provider_block.access_key
  secret_key = var.provider_block.secret_key
}

provider "aws" {
  alias  = "vg"
  region = var.provider_block.vg
}