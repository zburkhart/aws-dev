# Create IAM Users
resource "aws_iam_user" "iam_users" {
  for_each = var.iam_users
  name     = each.key

  tags = each.value.tags
}

# Create IAM Access Keys
resource "aws_iam_access_key" "access_keys" {
  for_each = var.iam_users
  user     = aws_iam_user.iam_users[each.key].name
}

# Create IAM Groups
resource "aws_iam_group" "iam_groups" {
  for_each = var.iam_groups
  name     = each.key
  path     = each.value
}
