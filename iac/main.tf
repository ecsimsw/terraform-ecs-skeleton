terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  backend "s3" {
    bucket         = "goqual-terraform-state"
    key            = "goqualcloud/aws/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "vpc"
}

module "ecr" {
  source = "ecr"
}