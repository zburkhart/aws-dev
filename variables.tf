variable "iam_users" {
  description = "Map of IAM users with names and tags"
  type = map(object({
    tags   = map(string)
    groups = list(string) # List of group names the user belongs to
  }))
}

variable "iam_groups" {
  description = "Map of IAM groups with names and paths"
  type = map(object({
    path = string
  }))
}

/*variable "iam_group_policies" {
  description = "Map of IAM groups to a single policy ARN"
  type        = map(string)
}*/
