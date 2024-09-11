##########################
# General Variables    #
##########################
# variable "environment" {
#   type        = string
#   description = "The name of the SDLC environment"
# }
# variable "aws_region" {
#   description = "The AWS region to deploy resources into."
#   type        = string
#   default     = "us-east-1"  # Replace with your desired region
# }

##########################
#     IAM Variables      #
##########################
variable "iam_users" {
  description = "List of IAM users"
  type = list(object({
    name   = string
    groups = list(string)
  }))
  default = []
}

variable "iam_groups" {
  description = "List of IAM groups"
  type = list(object({
    name     = string
    policies = list(string)
  }))
  default = []
}

variable "iam_policies" {
  description = "List of IAM policies"
  type = list(object({
    name            = string
    policy_document = string
  }))
  default = []
}

variable "policy_attachments" {
  description = "List of policy attachments"
  type = list(object({
    group  = string
    policy = string
  }))
  default = []
}

##########################
# S3 Bucket Variables    #
##########################
variable "buckets" {
  description = "Map of bucket configurations."
  type = map(object({
    lifecycle         = bool
    enable_encryption = bool
    policy            = string
  }))
  default = {}
}

##########################
#     VPC Variables      #
##########################
variable "vpc_name" {
  description = "The name of the VPC"
  default     = "vpc-primary"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  type = map(string)
  default = {
    public   = "10.0.1.0/24"
    private  = "10.0.2.0/24"
    apps     = "10.0.3.0/24"
    external = "10.0.4.0/24"
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

##########################
#  CloudFront Variables  #
##########################
# variable "cloudfront_distributions" {
#   description = "Map of CloudFront distributions to create."
#   type = map(object({
#     aliases                = list(string)
#     error_caching_min_ttl  = number
#     error_code             = string
#     response_code          = string
#     response_page_path     = string
#     cache_policy_id        = string
#     target_origin_id       = string
#     viewer_protocol_policy = string
#     default_ttl            = number
#     max_ttl                = number
#     min_ttl                = number
#     origin_domain_name     = string
#     origin_id              = string
#     acm_certificate_arn    = string
#   }))
# }

variable "cache_policies" {
  description = "Map of CloudFront cache policies to create."
  type = map(object({
    comment       = string
    default_ttl   = number
    max_ttl       = number
    min_ttl       = number
    enable_brotli = bool
    enable_gzip   = bool
  }))
}

variable "origin_access_control" {
  description = "Origin access control settings."
  type = object({
    name             = string
    description      = string
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  })
}

variable "acm_certificates" {
  description = "Map of ACM certificates to create."
  type = map(object({
    domain_name       = string
    validation_domain = string
  }))
}

##########################
#   Route53 Variables    #
##########################

####################
# RDS Variables    #
####################
# variable "rds_az" {
#   type        = string
#   description = "The RDS AZ"
# }

# variable "rds_min_storage" {
#   type        = number
#   description = "Minimum storage size avilable to the RDS instance in GB"
#   default     = 50
# }

# variable "rds_max_storage" {
#   type        = number
#   description = "Minimum storage size avilable to the RDS instance in GB"
#   default     = null
# }

# variable "rds_backup_retention_days" {
#   type        = number
#   description = "The number of days to retain backups for the the DRS instance."
#   default     = 7
# }

# variable "rds_db_name" {
#   type        = string
#   description = "The name of the RDS DB."
# }

# variable "rds_instance_class" {
#   type        = string
#   description = "The instance class of the RDS instance."
# }

# variable "rds_multi_az" {
#   type        = bool
#   description = "Wheter or not the RDS instance is multi AZ."
#   default     = false
# }

# variable "rds_port" {
#   type        = number
#   description = "The port of the RDS instance."
#   default     = 5432
# }

# variable "rds_publicly_accessible" {
#   type        = bool
#   description = "Whether or not the RDS instance is has a public ip."
#   default     = false
# }

# variable "rds_storage_type" {
#   type        = string
#   description = "The storage type for the RDS instance."
# }

# variable "rds_allow_ingress_ips" {
#   type        = list(string)
#   description = "List of CIDR ranges to allow ingress from into the RDS instance."
#   default     = []
# }

##############################
#  Secret Manager Variables  #
##############################
variable "secrets" {
  description = "A map containing objects where each ovject define a single secret manager secret"
  default     = {}
  type = map(object({
    secret_recovery = number // Retention Period (in days) for Recovering Deleted Secrets
  }))
}

####################################
# SSM Parameter Store Variables    #
####################################
variable "ssm_parameters" {
  description = "A map containing object where each object defines a single parameter store paremeter"
  default     = {}
  type = map(object({
    parameter_data_type = string // Data Type for SSM Parameters
    parameter_tier      = string // SSM Parameter Tier
    parameter_type      = string // SSM Parameter Type
    parameter_value     = string // SSM Parameter Value
  }))
}

#####################################
#Simple Email Service Identities    #
#####################################
variable "domain_identities" {
  type        = list(string)
  description = "List of domains to use with SES."
  default     = []
}

variable "email_identities" {
  type        = list(string)
  description = "List of email addresses to use with SES."
  default     = []
}