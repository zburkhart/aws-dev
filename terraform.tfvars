##########################
#          IAM           #
##########################
iam_users = [
  {
    name   = "Administrator"
    groups = ["admin-group", "power-user-access"]
  },
  {
    name   = "developer"
    groups = ["read-access-group"]
  }
]

iam_groups = [
  {
    name     = "admin-group"
    policies = ["AdministratorAccess", "PowerUserAccess"]
  },
  {
    name     = "power-user-access"
    policies = ["PowerUserAccess"]
  },
  {
    name     = "read-access-group"
    policies = ["ReadOnlyAccess"]
  }
]

iam_policies = [
  {
    name            = "AdministratorAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
  },
  {
    name            = "PowerUserAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"ec2:*\",\"s3:*\",\"iam:GetUser\",\"iam:ListAttachedUserPolicies\",\"iam:ListAttachedGroupPolicies\",\"iam:ListAttachedRolePolicies\",\"iam:ListGroupPolicies\",\"iam:ListRolePolicies\",\"iam:ListUserPolicies\",\"iam:GetPolicy\",\"iam:GetPolicyVersion\",\"iam:GetUserPolicy\",\"iam:GetGroupPolicy\",\"iam:GetRolePolicy\"],\"Resource\":\"*\"}]}"
  },
  {
    name            = "ReadOnlyAccess"
    policy_document = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
  }
]

policy_attachments = [
  {
    group  = "admin-group"
    policy = "AdministratorAccess"
  },
  {
    group  = "power-user-access"
    policy = "PowerUserAccess"
  },
  {
    group  = "read-access-group"
    policy = "ReadOnlyAccess"
  }
]
