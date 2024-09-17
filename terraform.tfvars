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

iam_roles = [
  {
    name               = "eks-cluster-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"eks.amazonaws.com\"}}]}"
  },
  {
    name               = "eks-node-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"ec2.amazonaws.com\"}}]}"
  }
]

iam_policies = [
  {
    name            = "AdministratorAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}",
  },
  {
    name            = "PowerUserAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"ec2:*\",\"s3:*\",\"iam:GetUser\",\"iam:ListAttachedUserPolicies\",\"iam:ListAttachedGroupPolicies\",\"iam:ListAttachedRolePolicies\",\"iam:ListGroupPolicies\",\"iam:ListRolePolicies\",\"iam:ListUserPolicies\",\"iam:GetPolicy\",\"iam:GetPolicyVersion\",\"iam:GetUserPolicy\",\"iam:GetGroupPolicy\",\"iam:GetRolePolicy\"],\"Resource\":\"*\"}]}",
  },
  {
    name            = "ReadOnlyAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}",
  }
]

role_policy_attachments = [
  {
    role       = "eks-cluster-role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  },
  {
    role       = "eks-node-role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  },
  {
    role       = "eks-node-role"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
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
    policy            = "{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::329599651317:distribution/E3KWVGKFT6KNFO\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::zb-me-prod/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
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
availability_zones = ["us-east-1a"] //["us-east-1a"], "us-east-1b"] Enable this for deployment in multiple AZs

subnet_cidr_blocks = {
  public  = "10.0.1.0/24"
  private = "10.0.2.0/24"
  apps    = "10.0.3.0/24"
  mgmt    = "10.0.4.0/24"
}

###############################################
#          CloudFront Configuration           #
###############################################
# cloudfront_distributions = {
#   "zb_me_cf_distribution" = {
#     aliases                = ["app.zach-burkhart.me"]
#     error_caching_min_ttl  = 300
#     error_code             = "403"
#     response_code          = "200"
#     response_page_path     = "/index.html"
#     cache_policy_id        = "CachingOptimized"
#     target_origin_id       = "zb-me-prod.s3.us-east-1.amazonaws.com"
#     viewer_protocol_policy = "https-only"
#     default_ttl            = 0
#     max_ttl                = 0
#     min_ttl                = 0
#     origin_domain_name     = "zb-me-prod.s3.us-east-1.amazonaws.com"
#     origin_id              = "zb-me_prod.s3.us-east-1.amazonaws.com"
#     acm_certificate_arn    = "arn:aws:acm:us-east-1:329599651317:certificate/042f8c94-f88c-4675-a481-e9dfe5a90937"
#   }
# "site_zb_cf_distribution" = {
#   aliases                = ["site.zach-burkhart.me"]
#   error_caching_min_ttl  = 500
#   error_code             = "403"
#   response_code          = "200"
#   response_page_path     = "/index.html"
#   cache_policy_id        = "CachingDisabled"
#   target_origin_id       = "site-zb-prod.s3.us-east-1.amazonaws.com"
#   viewer_protocol_policy = "https-only"
#   default_ttl            = 0
#   max_ttl                = 0
#   min_ttl                = 0
#   origin_domain_name     = "site-zb-prod.s3.us-east-1.amazonaws.com"
#   origin_id              = "site-zb-prod.s3.us-east-1.amazonaws.com"
#   acm_certificate_arn    = aws_acm_certificate.site_zb_prod_cert.arn
# }
#}

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
  "app_zb_prod_cert" = {
    domain_name       = "*.zach-burkhart.me"
    validation_domain = "zach-burkhart.me"
  },
  "site_zb_prod_cert" = {
    domain_name       = "zach-burkhart.me"
    validation_domain = "zach-burkhart.me"
  },
  "main_app_cert" = {
    domain_name       = "app.zach-burkhart.me"
    validation_domain = "zach-burkhart.me"
  }
}

###############################################
#              EKS Configuration              #
# ###############################################
# eks_clusters = {
#   dev = {
#     name               = "dev-cluster"
#     node_instance_type = "t2.nano"
#     min_nodes          = 2
#     max_nodes          = 3
#   },
#   prod = {
#     name               = "prod-cluster"
#     node_instance_type = "t2.micro"
#     min_nodes          = 3
#     max_nodes          = 5
#   }
# }

# eks_node_groups = {
#   dev-prometheus = {
#     cluster_name       = "dev-cluster"
#     node_group_name    = "dev-prometheus-node-group"
#     node_instance_type = "t2.small"
#     min_nodes          = 1
#     max_nodes          = 2
#   },
#   dev-grafana = {
#     cluster_name       = "dev-cluster"
#     node_group_name    = "dev-grafana-node-group"
#     node_instance_type = "t2.small"
#     min_nodes          = 1
#     max_nodes          = 2
#   },
#   prod-prometheus = {
#     cluster_name       = "prod-cluster"
#     node_group_name    = "prod-prometheus-node-group"
#     node_instance_type = "t2.medium"
#     min_nodes          = 2
#     max_nodes          = 3
#   },
#   prod-grafana = {
#     cluster_name       = "prod-cluster"
#     node_group_name    = "prod-grafana-node-group"
#     node_instance_type = "t2.medium"
#     min_nodes          = 2
#     max_nodes          = 3
#   }
# }

###############################################
#           Route53 Configuration             #
###############################################
hosted_zone_name = "zach-burkhart.me"

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