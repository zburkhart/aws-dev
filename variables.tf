##########################
#     IAM Variables      #
##########################
variable "iam_users" {
  description = "List of IAM users"
  type = list(object({
    name   = string
    groups = list(string)
  }))
  default = []
}

variable "iam_groups" {
  description = "List of IAM groups"
  type = list(object({
    name     = string
    policies = list(string)
  }))
  default = []
}

variable "iam_policies" {
  description = "List of IAM policies"
  type = list(object({
    name            = string
    policy_document = string
  }))
  default = []
}

variable "policy_attachments" {
  description = "List of policy attachments"
  type = list(object({
    group  = string
    policy = string
  }))
  default = []
}
