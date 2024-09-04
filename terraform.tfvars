##########################
#          IAM           #
##########################
iam_users = {
  "terraform" = {
    tags = {
      "tag-key" = "tag-value"
    }
  }
  "administrator" = {
    tags = {
      "tag-key" = "tag-value"
    }
  }
}

iam_groups = {
  "admin-group"       = { path = "/admins/" }
  "power-user-access" = { path = "/admins/" }
}


##########################
#          S3            #
##########################
