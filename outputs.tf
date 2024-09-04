output "access_keys" {
  value = {
    for key in aws_iam_access_key.access_keys : key.user => {
      id     = key.id
      secret = key.secret
    }
  }
}