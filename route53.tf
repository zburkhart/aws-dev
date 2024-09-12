### Route53 Zones ###
resource "aws_route53_zone" "route53_primary_zone" {
  name = var.hosted_zone_name # Replace with domain name
}