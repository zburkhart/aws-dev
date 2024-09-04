# Create IAM Groups
resource "aws_iam_group" "iam_groups" {
  for_each = var.iam_groups
  name     = each.key
  path     = each.value.path
}

# Define IAM Policies
resource "aws_iam_policy" "administrator_access" {
  name        = "AdministratorAccess"
  description = "Provides full access to all AWS services and resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "power_user_access" {
  name        = "PowerUserAccess"
  description = "Provides full access to AWS resources but not permissions management"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:*",
          "s3:*",
          "iam:GetUser",
          "iam:ListAttachedUserPolicies",
          "iam:ListAttachedGroupPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListGroupPolicies",
          "iam:ListRolePolicies",
          "iam:ListUserPolicies",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetUserPolicy",
          "iam:GetGroupPolicy",
          "iam:GetRolePolicy"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "read_only_access" {
  name        = "ReadOnlyAccess"
  description = "Provides read-only access to AWS resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

# Attach Policies to Groups
resource "aws_iam_policy_attachment" "group_policy_attachment" {
  for_each = { for group_name, policy_arns in var.iam_group_policies : group_name => policy_arns }

  name       = "${each.key}-policy-attachment"
  policy_arn = each.value[0] # If you have multiple policies, adjust this as needed
  groups     = [
    aws_iam_group.iam_groups[each.key].name
  ]
}

# Create IAM Users
resource "aws_iam_user" "iam_users" {
  for_each = var.iam_users
  name     = each.key
  tags     = each.value.tags
}

# Attach Users to Groups
resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = {
    for user_name, user_info in var.iam_users :
    user_name => user_info.groups
  }

  user = aws_iam_user.iam_users[each.key].name
  groups = each.value
}
