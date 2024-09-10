##########################
# General Variables    #
##########################

#environment = "prod"

##########################
#          IAM           #
##########################
iam_users = [
  {
    name   = "Administrator"
    groups = ["admin-group", "power-user-access"]
  },
  {
    name   = "developer"
    groups = ["read-access-group"]
  }
]

iam_groups = [
  {
    name     = "admin-group"
    policies = ["AdministratorAccess", "PowerUserAccess"]
  },
  {
    name     = "power-user-access"
    policies = ["PowerUserAccess"]
  },
  {
    name     = "read-access-group"
    policies = ["ReadOnlyAccess"]
  }
]

iam_policies = [
  {
    name            = "AdministratorAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
  },
  {
    name            = "PowerUserAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"ec2:*\",\"s3:*\",\"iam:GetUser\",\"iam:ListAttachedUserPolicies\",\"iam:ListAttachedGroupPolicies\",\"iam:ListAttachedRolePolicies\",\"iam:ListGroupPolicies\",\"iam:ListRolePolicies\",\"iam:ListUserPolicies\",\"iam:GetPolicy\",\"iam:GetPolicyVersion\",\"iam:GetUserPolicy\",\"iam:GetGroupPolicy\",\"iam:GetRolePolicy\"],\"Resource\":\"*\"}]}"
  },
  {
    name            = "ReadOnlyAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
  }
]

policy_attachments = [
  {
    group  = "admin-group"
    policy = "AdministratorAccess"
  },
  {
    group  = "power-user-access"
    policy = "PowerUserAccess"
  },
  {
    group  = "read-access-group"
    policy = "ReadOnlyAccess"
  }
]

###############################################
# S3 Bucket Configuration                     #
###############################################
# distribution_bucket    = "example-distribution-bucket"
# cloudtrail_logs_bucket = "example-cloudtril-logs-bucket"
# access_logs_bucket     = "example-cloudfront-access-logs-bucket"

# lifecycle_buckets = ["example-distribution-bucket"]
# buckets = {
#   "distribution_bucket" = {
#     bucket_name      = "example-distribution-bucket"
#     lifecycle        = {
#       transition_days = 30
#       expiration_days = 90
#     }
#     acl              = "private"
#     server_side_encryption = {
#       kms_key_id = "your-kms-key-id"
#       sse_algorithm = "aws:kms"
#     }
#     policies = []
#   },
#   "cloudtrail_logs_bucket" = {
#     bucket_name      = "example-cloudtrail-logs-bucket"
#     lifecycle        = {
#       transition_days = 30
#       expiration_days = 365
#     }
#     acl              = "private"
#     server_side_encryption = {
#       kms_key_id = "your-kms-key-id"
#       sse_algorithm = "aws:kms"
#     }
#     policies = []
#   }
# }

###############################################
# SSM Parameter Configuration                 #
###############################################

ssm_parameters = {}

###############################################
# Secret Manager Secrets Configuration        #
###############################################
secrets = {
  "example-client" = {
    secret_recovery = 7
  }
  #   "fasten" = {
  #     secret_recovery = 7
  #   },
  #   "fasten_rds" = {
  #     secret_recovery = 7
  #   }
}

###############################################
# Simple Email Service (SES) Configuration    #
###############################################
domain_identities = [] #["fasten.cc"]

#####################
# RDS Configuration #
#####################
# rds_az                = "us-east-2b"
# rds_db_name           = "ExampleProd"
# rds_instance_class    = "db.t3.medium"
# rds_max_storage       = 1000
# rds_storage_type      = "gp2"
# rds_allow_ingress_ips = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]

###############################
# Elastic Beanstalk Variables #
###############################

# el_bnstlk_env_name = "example-api-prod-env-active"