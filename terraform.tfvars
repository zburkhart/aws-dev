##########################
#          IAM           #
##########################
iam_users = {
  "administrator" = {
    tags   = { "Role" = "Admin" }
    groups = ["admin-group"]
  }
  "developer" = {
    tags   = { "Role" = "Viewer" }
    groups = ["read-access-group"]
  }
}

iam_groups = {
  "admin-group"       = { path = "/admins/" }
  "power-user-access" = { path = "/users/" }
  "read-access-group" = { path = "/readers/" }
}

/*iam_group_policies = {
  "admin-group"       = aws_iam_policy.administrator_access.arn
  "power-user-access" = aws_iam_policy.power_user_access.arn
  "read-access-group" = aws_iam_policy.read_only_access.arn
}*/

##########################
#          S3            #
##########################
