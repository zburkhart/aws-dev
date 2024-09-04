##########################
# AWS Providers          #
##########################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "aws-dev-tf-state"
    key            = "aws-dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-dev-tfstate-locking"
    encrypt        = true
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  default_tags {
    tags = {
      provisioner = "terraform"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      provisioner = "terraform"
    }
  }
}