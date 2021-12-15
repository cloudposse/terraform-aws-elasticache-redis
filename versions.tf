terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.26"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
