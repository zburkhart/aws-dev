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

  # backend "s3" {
  #   bucket         = "aws-zbb-dev-tf-state"
  #   key            = "aws-zbb-dev-tf-state/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "aws-zbb-dev-tfstate-locking"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      provisioner = "terraform"
    }
  }
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
  default_tags {
    tags = {
      provisioner = "terraform"
    }
  }
}

provider "helm" {
  alias = "helm"
  kubernetes {
    config_path = "~/.kube/config"
  }
}