### CloudFront Distributions ###
resource "aws_cloudfront_distribution" "cloudfront_distributions" {
  for_each = var.cloudfront_distributions

  aliases = each.value.aliases

  depends_on = [aws_cloudfront_cache_policy.cache_policy]

  custom_error_response {
    error_caching_min_ttl = each.value.error_caching_min_ttl
    error_code            = each.value.error_code
    response_code         = each.value.response_code
    response_page_path    = each.value.response_page_path
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy[each.value.cache_policy_id].id
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = each.value.default_ttl
    max_ttl                = each.value.max_ttl
    min_ttl                = each.value.min_ttl
    smooth_streaming       = false
    target_origin_id       = each.value.origin_id
    viewer_protocol_policy = each.value.viewer_protocol_policy
  }

  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = each.value.origin_domain_name
    origin_id                = each.value.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = false
  staging          = false

  viewer_certificate {
    acm_certificate_arn            = each.value.acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.origin_access_control.name
  description                       = var.origin_access_control.description
  origin_access_control_origin_type = var.origin_access_control.origin_type
  signing_behavior                  = var.origin_access_control.signing_behavior
  signing_protocol                  = var.origin_access_control.signing_protocol
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  for_each = var.cache_policies

  name        = each.key
  comment     = each.value.comment
  default_ttl = each.value.default_ttl
  max_ttl     = each.value.max_ttl
  min_ttl     = each.value.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    enable_accept_encoding_brotli = each.value.enable_brotli
    enable_accept_encoding_gzip   = each.value.enable_gzip

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_acm_certificate" "acm_certificate" {
  for_each = var.acm_certificates

  domain_name       = each.value.domain_name
  validation_method = "DNS"

  validation_option {
    domain_name       = each.value.domain_name
    validation_domain = each.value.validation_domain
  }

  lifecycle {
    create_before_destroy = true
  }
}

### Notes ###
# Cache Policy IDs, OAC, and ACM Certificate ARNs must be known prior to deploying CF distributions - Use outputs to retrieve values