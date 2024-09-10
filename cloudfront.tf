# ### Define CloudFront Distribution Resources ###
# resource "aws_cloudfront_distribution" "tf_test_app_cf_distribution" {
#   aliases = ["zachinactionmain.fasten.cc"]

#   custom_error_response {
#     error_caching_min_ttl = "300"
#     error_code            = "403"
#     response_code         = "200"
#     response_page_path    = "/index.html"
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cache_policy_id        = aws_cloudfront_cache_policy.CachingOptimized.id
#     cached_methods         = ["GET", "HEAD"]
#     compress               = "true"
#     default_ttl            = "0"
#     max_ttl                = "0"
#     min_ttl                = "0"
#     smooth_streaming       = "false"
#     target_origin_id       = "zachinactionmain.s3.us-east-2.amazonaws.com"
#     viewer_protocol_policy = "https-only"
#   }

#   default_root_object = "index.html"
#   enabled             = "true"
#   http_version        = "http2"
#   is_ipv6_enabled     = "true"

#   origin {
#     connection_attempts      = "3"
#     connection_timeout       = "10"
#     domain_name              = "zachinaction.s3.us-east-2.amazonaws.com"
#     origin_id                = "zachinaction.s3.us-east-2.amazonaws.com"
#     origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
#   }

# #   logging_config {
# #     include_cookies = false
# #     bucket          = aws_s3_bucket.access_logs_bucket.bucket_domain_name
# #     prefix          = "logs/fasten-client/"
# #   }

#   price_class = "PriceClass_All"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   retain_on_delete = "false"
#   staging          = "false"

#   viewer_certificate {
#     acm_certificate_arn            = aws_acm_certificate.tf_test_main_app_cert.arn
#     cloudfront_default_certificate = false
#     minimum_protocol_version       = "TLSv1.2_2021"
#     ssl_support_method             = "sni-only"
#   }
# }

# resource "aws_cloudfront_distribution" "rewards_admin_client_cf_distribution" {
#   aliases = ["rewards-admin-prod.fasten.cc"]

#   custom_error_response {
#     error_caching_min_ttl = "500"
#     error_code            = "403"
#     response_code         = "200"
#     response_page_path    = "/index.html"
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cache_policy_id        = aws_cloudfront_cache_policy.CachingDisabled.id
#     cached_methods         = ["GET", "HEAD"]
#     compress               = "true"
#     default_ttl            = "0"
#     max_ttl                = "0"
#     min_ttl                = "0"
#     smooth_streaming       = "false"
#     target_origin_id       = "rewards-admin-client-prod.s3.us-east-2.amazonaws.com"
#     viewer_protocol_policy = "https-only"
#   }

#   default_root_object = "index.html"
#   enabled             = "true"
#   http_version        = "http2"
#   is_ipv6_enabled     = "true"

#   origin {
#     connection_attempts      = "3"
#     connection_timeout       = "10"
#     domain_name              = "rewards-admin-client-prod.s3.us-east-2.amazonaws.com"
#     origin_id                = "rewards-admin-client-prod.s3.us-east-2.amazonaws.com"
#     origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
#   }

# #   logging_config {
# #     include_cookies = false
# #     bucket          = aws_s3_bucket.access_logs_bucket.bucket_domain_name
# #     prefix          = "logs/rewards-admin-client/"
# #   }

#   price_class = "PriceClass_All"

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   retain_on_delete = "false"
#   staging          = "false"

#   viewer_certificate {
#     acm_certificate_arn            = aws_acm_certificate.tf_test_secondary_app_cert.arn
#     cloudfront_default_certificate = false
#     minimum_protocol_version       = "TLSv1.2_2021"
#     ssl_support_method             = "sni-only"
#   }
# }

# ### Define CloudFront Cache Policies ###
# resource "aws_cloudfront_cache_policy" "CachingOptimized" {
#   comment     = "Policy with caching enabled. Supports Gzip and Brotli compression."
#   default_ttl = "300"
#   max_ttl     = "300"
#   min_ttl     = "0"
#   name        = "CachingOptimized"

#   parameters_in_cache_key_and_forwarded_to_origin {
#     cookies_config {
#       cookie_behavior = "none"
#     }

#     enable_accept_encoding_brotli = "true"
#     enable_accept_encoding_gzip   = "true"

#     headers_config {
#       header_behavior = "none"
#     }

#     query_strings_config {
#       query_string_behavior = "none"
#     }
#   }
# }

# resource "aws_cloudfront_cache_policy" "CachingDisabled" {
#   comment     = "Policy with caching disabled"
#   default_ttl = "300"
#   max_ttl     = "300"
#   min_ttl     = "0"
#   name        = "CachingDisabled"

#   parameters_in_cache_key_and_forwarded_to_origin {
#     cookies_config {
#       cookie_behavior = "none"
#     }

#     enable_accept_encoding_brotli = "false"
#     enable_accept_encoding_gzip   = "false"

#     headers_config {
#       header_behavior = "none"
#     }

#     query_strings_config {
#       query_string_behavior = "none"
#     }
#   }
# }

# ### Create S3 Origin Access Control ID ###
# resource "aws_cloudfront_origin_access_control" "s3_oac" {
#   name                              = "s3-oac"
#   description                       = "OAC for accessing S3 bucket"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }


# ### Create ACM Certificates and Validate with Domain ###
# resource "aws_acm_certificate" "tf_test_main_app_cert" {
#   provider          = aws.us_east_1
#   domain_name       = "zachinactionmain.fasten.cc"
#   validation_method = "DNS"

#   validation_option {
#     domain_name       = "zachinactionmain.fasten.cc"
#     validation_domain = "fasten.cc"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate" "tf_test_secondary_app_cert" {
#   provider          = aws.us_east_1
#   domain_name       = "zachinactionsecondary.fasten.cc"
#   validation_method = "DNS"

#   validation_option {
#     domain_name       = "zachinactionsecondary.fasten.cc"
#     validation_domain = "fasten.cc"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }