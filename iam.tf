### Create IAM Users ###
resource "aws_iam_user" "users" {
  for_each = { for user in var.iam_users : user.name => user }

  name = each.value.name
}

### Create IAM Roles ###
resource "aws_iam_role" "roles" {
  for_each = { for role in var.iam_roles : role.name => role }

  name               = each.value.name
  assume_role_policy = each.value.assume_role_policy

  tags = {
    Name = each.value.name
  }
}

### Create IAM Groups ###
resource "aws_iam_group" "groups" {
  for_each = { for group in var.iam_groups : group.name => group }

  name = each.value.name

  depends_on = [aws_iam_user.users] # Ensure IAM users are created before assigning them to groups
}

### Add IAM Users to Groups ###
resource "aws_iam_user_group_membership" "user_groups" {
  for_each = { for user in var.iam_users : user.name => user }

  user   = each.value.name
  groups = each.value.groups
}

### Define IAM Policies ###
resource "aws_iam_policy" "policies" {
  for_each = { for policy in var.iam_policies : policy.name => policy }

  name   = each.value.name
  policy = each.value.policy_document
}

### Attach IAM Policies to Groups ###
resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each = { for attachment in var.policy_attachments : "${attachment.group}-${attachment.policy}" => attachment }

  group      = aws_iam_group.groups[each.value.group].name
  policy_arn = aws_iam_policy.policies[each.value.policy].arn
}
