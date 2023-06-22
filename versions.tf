terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.18"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}
