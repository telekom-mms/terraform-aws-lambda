// main.tf
# Written by Marc Straubinger - Overhauled for Security-First Best Practices

# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"
  role          = var.role_arn != "" ? var.role_arn : aws_iam_role.lambda_role[0].arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  description   = var.description

  architectures = var.architectures

  filename          = var.filename
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  source_code_hash = var.source_code_hash

  lifecycle {
    precondition {
      condition = (
        try(trimspace(var.filename), "") != "" ||
        (try(trimspace(var.s3_bucket), "") != "" && try(trimspace(var.s3_key), "") != "")
      )
      error_message = "Either filename or s3_bucket with s3_key must be provided as a code source."
    }

    precondition {
      condition     = !var.snap_start || can(regex("^java", var.runtime))
      error_message = "snap_start is only supported for Java runtimes (java11, java17, java21)."
    }
  }

  # PSA Compliance: Req 9 (controlled function concurrency)
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  # PSA Compliance: Req 3.50-01 (environment variable encryption)
  kms_key_arn = var.kms_key_arn != "" ? var.kms_key_arn : null

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [1] : []
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [1] : []
    content {
      target_arn = var.dead_letter_config.target_arn
    }
  }

  tracing_config {
    mode = var.tracing_mode
  }

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  dynamic "snap_start" {
    for_each = var.snap_start ? [1] : []
    content {
      apply_on = "PublishedVersions"
    }
  }

  tags = merge(local.common_tags, {
    "Name"          = var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"
    "PSA-Compliant" = "true"
  })
}

# IAM Role for Lambda (if not provided)
resource "aws_iam_role" "lambda_role" {
  count = var.role_arn == "" ? 1 : 0
  name  = "${var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    "Name"          = "${var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"}-role"
    "PSA-Compliant" = "true"
  })
}

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  count      = var.role_arn == "" ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# VPC execution policy (if VPC config is provided)
resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  count      = var.role_arn == "" && var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Additional managed policy attachments
resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = var.role_arn == "" ? toset(var.iam_policy_arns) : []
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = each.value
}

# Custom inline policy
resource "aws_iam_role_policy" "custom" {
  count  = var.role_arn == "" && var.custom_iam_policy != "" ? 1 : 0
  name   = "lambda-custom-policy"
  role   = aws_iam_role.lambda_role[0].id
  policy = var.custom_iam_policy
}

# Lambda Function URL
# PSA Compliance: Req 3.01-06 (authenticated function URLs)
resource "aws_lambda_function_url" "this" {
  count              = var.enable_function_url ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = var.function_url_auth_type

  lifecycle {
    precondition {
      condition     = var.function_url_auth_type != "NONE" || var.allow_public_function_url
      error_message = "allow_public_function_url must be true when function_url_auth_type is NONE."
    }
  }

  dynamic "cors" {
    for_each = var.function_url_cors != null ? [1] : []
    content {
      allow_credentials = var.function_url_cors.allow_credentials
      allow_headers     = var.function_url_cors.allow_headers
      allow_methods     = var.function_url_cors.allow_methods
      allow_origins     = var.function_url_cors.allow_origins
      expose_headers    = var.function_url_cors.expose_headers
      max_age           = var.function_url_cors.max_age
    }
  }
}

# Lambda Permissions
resource "aws_lambda_permission" "this" {
  for_each = var.lambda_permissions

  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = aws_lambda_function.this.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}

# Lambda Alias
resource "aws_lambda_alias" "this" {
  for_each = var.lambda_aliases

  name             = each.key
  description      = each.value.description
  function_name    = aws_lambda_function.this.function_name
  function_version = each.value.function_version
}

# CloudWatch Log Group
# PSA Compliance: Req 3.66-05 (mandatory logging with optional KMS encryption)
resource "aws_cloudwatch_log_group" "lambda_logs" {
  count             = var.create_log_group ? 1 : 0
  name              = "/aws/lambda/${var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.log_group_kms_key_arn

  tags = merge(local.common_tags, {
    "Name"          = "/aws/lambda/${var.function_name != "" ? var.function_name : "${local.name_prefix}-lambda"}"
    "PSA-Compliant" = "true"
  })
}
