### S3 Bucket Definitions ###
resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets

  bucket        = each.key
  force_destroy = true
}

### S3 Bucket Website Configuration ###
resource "aws_s3_bucket_website_configuration" "website_config" {
  for_each = {
    for bucket_name, config in var.buckets : bucket_name => config if bucket_name == "zb-me-prod"
  }

  bucket = aws_s3_bucket.buckets[each.key].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

### S3 Bucket Server-Side Encryption Configuration ###
resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  for_each = { for bucket_name, config in var.buckets : bucket_name => config if config.enable_encryption }

  bucket = aws_s3_bucket.buckets[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_master_key.arn
      sse_algorithm     = "aws:kms"
    }
  }

  depends_on = [aws_s3_bucket.buckets]
}

### S3 Bucket Lifecycle Configurations ###
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration" {
  for_each = { for bucket_name, config in var.buckets : bucket_name => config if config.lifecycle }

  bucket = aws_s3_bucket.buckets[each.key].id

  rule {
    id     = "storage-class-transition"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "ONEZONE_IA"
    }
  }

  rule {
    id     = "expire-objects"
    status = "Enabled"
    filter {
      prefix = "" # Empty prefix means the rule applies to all objects
    }
    expiration {
      days = 90 # Number of days after which the objects will be deleted
    }
  }

  depends_on = [aws_s3_bucket.buckets]
}

### S3 Bucket Policies ###
resource "aws_s3_bucket_policy" "bucket_policies" {
  for_each = { for bucket_name, config in var.buckets : bucket_name => config if config.policy != "" }

  bucket = aws_s3_bucket.buckets[each.key].id
  policy = each.value.policy

  depends_on = [aws_s3_bucket.buckets]
}
