variable "iam_users" {
  description = "Map of IAM users with names and tags"
  type = map(object({
    tags = map(string)
  }))
}

variable "iam_groups" {
  description = "Map of IAM groups with names and paths"
  type = map(object({
    path = string
  }))
}
