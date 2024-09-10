### Output for CloudFront Cache Policies ###
output "cache_policy_ids" {
  description = "The IDs of the CloudFront cache policies."
  value = {
    for key, policy in aws_cloudfront_cache_policy.cache_policy :
    key => policy.id
  }
}

### Output for ACM Certificates ###
output "acm_certificate_arns" {
  description = "The ARNs of the ACM certificates."
  value = {
    for key, cert in aws_acm_certificate.acm_certificate :
    key => cert.arn
  }
}

### Output for Access Keys ###
/*output "access_keys" {
  value = {
    for key in aws_iam_access_key.access_keys : key.user => {
      id     = key.id
      secret = key.secret
    }
  }
}*/