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
  "admin-group"       = "/admins/"
  "power-user-access" = "/admins/"
}
