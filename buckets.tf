# ### S3 Bucket Definitions ###
# resource "aws_s3_bucket" "distribution_bucket" {
#   bucket        = var.distribution_bucket
#   force_destroy = true
# }

# resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
#   bucket        = var.cloudtrail_logs_bucket
#   force_destroy = true
# }

# resource "aws_s3_bucket" "access_logs_bucket" {
#   bucket        = var.access_logs_bucket
#   force_destroy = true
# }

# ### Object Ownership Controls for Access Logs Bucket ###
# resource "aws_s3_bucket_ownership_controls" "access_logs_bucket_ownership_controls" {
#   bucket = aws_s3_bucket.access_logs_bucket.id

#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# #### S3 CF Bucket ACLs ###
# resource "aws_s3_bucket_acl" "access_logs_bucket_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.access_logs_bucket_ownership_controls]

#   bucket = aws_s3_bucket.access_logs_bucket.id
#   access_control_policy {
#     owner {
#       id = data.aws_canonical_user_id.current.id
#     }
#     grant {
#       grantee {
#         id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0" //Grants FULL_CONTROL to the awslogsdelivery service
#         type = "CanonicalUser"
#       }
#       permission = "FULL_CONTROL"
#     }
#   }
# }

# ### S3 Bucket Lifecycle Configurations ###
# resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_lifecycle_configuration" {
#   bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
#   rule {
#     id     = "storage-class-transition"
#     status = "Enabled"
#     transition {
#       days          = 30
#       storage_class = "ONEZONE_IA"
#     }
#   }
#   rule {
#     id     = "expire-objects"
#     status = "Enabled"
#     filter {
#       prefix = "" # Empty prefix means the rule applies to all objects
#     }
#     expiration {
#       days = 365 # Number of days after which the objects will be deleted
#     }
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "access_logs_lifecycle_configuration" {
#   for_each = toset(var.lifecycle_buckets)

#   bucket = each.key

#   rule {
#     id     = "storage-class-transition"
#     status = "Enabled"

#     transition {
#       days          = 30
#       storage_class = "ONEZONE_IA"
#     }
#   }

#   rule {
#     id     = "expire-objects"
#     status = "Enabled"

#     filter {
#       prefix = "" # Empty prefix means the rule applies to all objects
#     }

#     expiration {
#       days = 90 # Number of days after which the objects will be deleted
#     }
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "fasten_cloudtrail_logs_sse_config" {
#   bucket = aws_s3_bucket.cloudtrail_logs_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.kms_master_key.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# ### S3 Bucket Policies ###
# resource "aws_s3_bucket_policy" "distribution_bucket_policy" {
#   bucket = aws_s3_bucket.distribution_bucket.id
#   policy = "{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::767398074970:distribution/ED4TYWEMDMSQZ\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::fasten-client-prod/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
# }

# ### Data Sources ###
# data "aws_canonical_user_id" "current" {}

### Dynamic S3 Bucket Creation ###
# resource "aws_s3_bucket" "buckets" {
#   for_each = var.buckets

#   bucket        = each.value.bucket_name
#   force_destroy = true
# }

# ### S3 Bucket ACLs ###
# resource "aws_s3_bucket_acl" "buckets_acl" {
#   for_each = var.buckets

#   bucket = aws_s3_bucket.buckets[each.key].id
#   acl    = each.value.acl

#   depends_on = [aws_s3_bucket_ownership_controls.buckets_ownership_controls]
# }

# ### S3 Bucket Lifecycle Configurations ###
# resource "aws_s3_bucket_lifecycle_configuration" "buckets_lifecycle" {
#   for_each = var.buckets

#   bucket = aws_s3_bucket.buckets[each.key].id

#   rule {
#     id     = "storage-class-transition"
#     status = "Enabled"

#     transition {
#       days          = each.value.lifecycle.transition_days
#       storage_class = "ONEZONE_IA"
#     }
#   }

#   rule {
#     id     = "expire-objects"
#     status = "Enabled"

#     filter {
#       prefix = "" # Empty prefix means the rule applies to all objects
#     }

#     expiration {
#       days = each.value.lifecycle.expiration_days
#     }
#   }
# }

# ### S3 Bucket Server Side Encryption ###
# resource "aws_s3_bucket_server_side_encryption_configuration" "buckets_sse" {
#   for_each = var.buckets

#   bucket = aws_s3_bucket.buckets[each.key].id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = each.value.server_side_encryption.kms_key_id
#       sse_algorithm     = each.value.server_side_encryption.sse_algorithm
#     }
#   }
# }

# ### S3 Bucket Policies ###
# resource "aws_s3_bucket_policy" "buckets_policy" {
#   for_each = { for b in var.buckets : b.bucket_name => b if length(b.policies) > 0 }

#   bucket = aws_s3_bucket.buckets[each.key].id
#   policy = join("", each.value.policies)
# }

# ### Data Sources ###
# data "aws_canonical_user_id" "current" {}
