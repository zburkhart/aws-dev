### Deploys Secret Manager Secret Resources ###
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name                    = each.key
  recovery_window_in_days = each.value.secret_recovery
  kms_key_id              = aws_kms_key.kms_master_key.id
}

### Deploys AWS Managed KMS Master Key Resource ###
resource "aws_kms_key" "kms_master_key" {
  deletion_window_in_days = 10
  enable_key_rotation     = true
  rotation_period_in_days = 90
}

/*resource "aws_kms_key_policy" "fasten_kms_master_key_policy" {
  key_id = aws_kms_key.fasten_kms_master_key.id
  policy = jsonencode({ "Version" : "2012-10-17", "Id" : "key-policy-id", "Statement" : [{ "Sid" : "Allow administration of the key", "Effect" : "Allow", "Principal" : { "AWS" : "arn:aws:iam::767398074970:user/terraform" }, "Action" : ["kms:CreateKey", "kms:DescribeKey", "kms:ListAliases", "kms:ListResourceTags", "kms:PutKeyPolicy", "kms:ScheduleKeyDeletion", "kms:UpdateAlias", "kms:UpdateKeyDescription", "kms:TagResource", "kms:UntagResource"], "Resource" : "*" }, { "Sid" : "Allow use of the key for encryption and decryption", "Effect" : "Allow", "Principal" : { "AWS" : "arn:aws:iam::767398074970:user/terraform" }, "Action" : ["kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey", "kms:GenerateDataKeyWithoutPlaintext"], "Resource" : "*", "Condition" : { "StringEquals" : { "kms:EncryptionContext:aws:s3:bucket" : "arn:aws:s3:::access_logs_bucket" } } }, { "Sid" : "Allow CloudFront to use the key to deliver logs", "Effect" : "Allow", "Principal" : { "Service" : "delivery.logs.amazonaws.com" }, "Action" : "kms:GenerateDataKey*", "Resource" : "*" }] })
}*/