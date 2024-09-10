### Route53 Zones ###
resource "aws_route53_zone" "route53_primary_zone" {
  name = "zach-burkhart.me" # Replace with domain name
}