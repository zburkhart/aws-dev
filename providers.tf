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

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# # Define Prometheus Helm chart
# resource "helm_release" "prometheus" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   version    = "15.2.1"

#   values = [
#     file("prometheus-values.yaml")
#   ]
# }

# # Define Grafana Helm chart
# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   version    = "6.56.0"

#   values = [
#     file("grafana-values.yaml")
#   ]
# }