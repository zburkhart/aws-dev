# # Define the CloudTrail resource
# resource "aws_cloudtrail" "fasten_cloudtrail" {
#   name                          = "fasten-cloudtrail-prod"
#   s3_bucket_name                = aws_s3_bucket.cloudtrail_logs_bucket.id
#   s3_key_prefix                 = "CloudTrail"
#   include_global_service_events = true

#   depends_on = [
#     aws_s3_bucket_policy.cloudtrail_logs_bucket_policy,
#     aws_s3_bucket.cloudtrail_logs_bucket
#   ]
# }

# # Define IAM policy document for CloudTrail to access S3 bucket
# data "aws_iam_policy_document" "cloudtrail_iam_policy_document" {
#   statement {
#     sid    = "AWSCloudTrailAclCheck"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudtrail.amazonaws.com"]
#     }

#     actions   = ["s3:GetBucketAcl"]
#     resources = [aws_s3_bucket.cloudtrail_logs_bucket.arn]

#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/fasten-cloudtrail-prod"]
#     }
#   }

#   statement {
#     sid    = "AWSCloudTrailWrite"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudtrail.amazonaws.com"]
#     }

#     actions   = ["s3:PutObject"]
#     resources = ["${aws_s3_bucket.cloudtrail_logs_bucket.arn}/CloudTrail/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "s3:x-amz-acl"
#       values   = ["bucket-owner-full-control"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/fasten-cloudtrail-prod"]
#     }
#   }
# }

# # Define S3 bucket policy
# resource "aws_s3_bucket_policy" "cloudtrail_logs_bucket_policy" {
#   bucket = aws_s3_bucket.cloudtrail_logs_bucket.id
#   policy = data.aws_iam_policy_document.cloudtrail_iam_policy_document.json
# }

# # Data sources for dynamic values
# data "aws_caller_identity" "current" {}

# data "aws_partition" "current" {}

# data "aws_region" "current" {}