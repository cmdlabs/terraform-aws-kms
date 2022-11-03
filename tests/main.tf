terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 4.25.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Deployment = var.deployment_id
    }
  }
}
