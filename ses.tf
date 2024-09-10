# Register Domain Identities with AWS SES
resource "aws_ses_domain_identity" "ses_domain_identity" {
  for_each = toset(var.domain_identities)
  domain   = each.key
}

# Register Email Identities with AWS SES
resource "aws_ses_email_identity" "ses_email_identities" {
  for_each = toset(var.email_identities)
  email    = each.key
}