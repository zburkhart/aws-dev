##########################
# General Variables    #
##########################
# variable "environment" {
#   type        = string
#   description = "The name of the SDLC environment"
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
# variable "distribution_bucket" {
#   type = string
# }

# variable "cloudtrail_logs_bucket" {
#   type = string
# }

# variable "access_logs_bucket" {
#   type = string
# }

# variable "lifecycle_buckets" {
#   description = "List of S3 bucket names to apply lifecycle configurations"
#   type        = list(string)
# }
variable "buckets" {
  description = "Map of bucket configurations."
  type = map(object({
    lifecycle = bool
    policy    = string
  }))
  default = {}
}


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
#Secret Manager Variables    #
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