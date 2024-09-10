### Defines & Deploys SSM Parameter Resources ###
resource "aws_ssm_parameter" "ssm_parameters" {
  for_each = var.ssm_parameters

  name = each.key
  #arn         = "each.value.arn"
  data_type = each.value.parameter_data_type
  tier      = each.value.parameter_tier
  type      = each.value.parameter_type
  value     = each.value.parameter_value
}