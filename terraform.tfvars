##########################
# General Variables    #
##########################
#environment    = "prod"
#aws_region     = "us-east-1"

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
#         S3 Bucket Configuration             #
###############################################
buckets = {
  zb-me-prod = {
    lifecycle         = false
    enable_encryption = true
    policy            = "{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::329599651317:distribution/EQVO2WEK1DO1X\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::zb-me-prod/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
  }

  site-zb-prod = {
    lifecycle         = false
    enable_encryption = true
    policy            = "" #"{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::767398074970:distribution/ED4TYWEMDMSQZ\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::fasten-client-prod/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
  }

  #   tf-test-cloudtrail-logs-bucket = {
  #     lifecycle         = true
  #     enable_encryption = true
  #     policy            = ""
  #   }
  # }
  #   tf-test-access-logs-bucket = {
  #     lifecycle = false
  #     policy     = ""
}

###############################################
#              VPC Configuration              #
###############################################
availability_zones = ["us-east-1a", "us-east-1b"]

subnet_cidr_blocks = {
  public   = "10.0.1.0/24"
  private  = "10.0.2.0/24"
  apps     = "10.0.3.0/24"
  external = "10.0.4.0/24"
}

###############################################
#          CloudFront Configuration           #
###############################################
cloudfront_distributions = {
  "zb_me_cf_distribution" = {
    aliases                = ["app.zach-burkhart.me"]
    error_caching_min_ttl  = 300
    error_code             = "403"
    response_code          = "200"
    response_page_path     = "/index.html"
    cache_policy_id        = "CachingOptimized"
    target_origin_id       = "zb-me-prod.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "https-only"
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    origin_domain_name     = "zb-me-prod.s3.us-east-1.amazonaws.com"
    origin_id              = "zb-me_prod.s3.us-east-1.amazonaws.com"
    acm_certificate_arn    = "arn:aws:acm:us-east-1:329599651317:certificate/80faf01b-bcc0-43d2-b7b9-02f83167c3aa"
  }
  "site_zb_cf_distribution" = {
    aliases                = ["site.zach-burkhart.me"]
    error_caching_min_ttl  = 500
    error_code             = "403"
    response_code          = "200"
    response_page_path     = "/index.html"
    cache_policy_id        = "CachingDisabled"
    target_origin_id       = "site-zb-prod.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "https-only"
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    origin_domain_name     = "site-zb-prod.s3.us-east-1.amazonaws.com"
    origin_id              = "site-zb-prod.s3.us-east-1.amazonaws.com"
    acm_certificate_arn    = "arn:aws:acm:us-east-1:329599651317:certificate/f89067ef-0def-45ad-b610-2f01638718ef"
  }
}

cache_policies = {
  "CachingOptimized" = {
    comment       = "Policy with caching enabled. Supports Gzip and Brotli compression."
    default_ttl   = 300
    max_ttl       = 300
    min_ttl       = 0
    enable_brotli = true
    enable_gzip   = true
  },
  "CachingDisabled" = {
    comment       = "Policy with caching disabled"
    default_ttl   = 300
    max_ttl       = 300
    min_ttl       = 0
    enable_brotli = false
    enable_gzip   = false
  }
}

origin_access_control = {
  name             = "s3-oac"
  description      = "OAC for accessing S3 bucket"
  origin_type      = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

acm_certificates = {
  "zb_me_prod_acm_cert" = {
    domain_name       = "app.zach-burkhart.me"
    validation_domain = "zach-burkhart.me"
  },
  "site_zb_prod_cert" = {
    domain_name       = "zach-burkhart.me"
    validation_domain = "zach-burkhart.me"
  }
}

###############################################
#           Route53 Configuration             #
###############################################
# domain_name  = "zach-burkhart.me"
# subdomain    = "app.zach-burkhart.me"
# cname_target = "" #Replace with frontend CloudFront URL

###############################################
#        SSM Parameter Configuration          #
###############################################

ssm_parameters = {}

###############################################
#    Secret Manager Secrets Configuration     #
###############################################
secrets = {
  "example-kms-master-key" = {
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
#   Simple Email Service (SES) Configuration  #
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