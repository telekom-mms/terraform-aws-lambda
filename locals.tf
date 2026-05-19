// locals.tf

locals {
  name_prefix   = var.name_prefix != "" ? var.name_prefix : "${var.project_name}-${var.environment}"
  function_name = var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"

  common_tags = merge(var.tags, {
    "Project"       = var.project_name
    "Environment"   = var.environment
    "ManagedBy"     = "Terraform"
    "PSA-Compliant" = "true"
  })
}
