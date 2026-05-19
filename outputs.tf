// outputs.tf

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.this.qualified_arn
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_version" {
  description = "Version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "function_last_modified" {
  description = "Date this resource was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "function_source_code_hash" {
  description = "Base64-encoded representation of raw SHA-256 sum of the zip file"
  value       = aws_lambda_function.this.source_code_hash
}

output "function_source_code_size" {
  description = "Size in bytes of the function .zip file"
  value       = aws_lambda_function.this.source_code_size
}

output "role_arn" {
  description = "ARN of the IAM role used by the Lambda function"
  value       = var.role_arn != "" ? var.role_arn : aws_iam_role.lambda_role[0].arn
}

output "role_name" {
  description = "Name of the IAM role used by the Lambda function"
  value       = var.role_arn != "" ? null : aws_iam_role.lambda_role[0].name
}

output "function_url" {
  description = "URL of the Lambda function (if enabled)"
  value       = var.enable_function_url ? aws_lambda_function_url.this[0].function_url : null
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.lambda_logs[0].name : null
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = var.create_log_group ? aws_cloudwatch_log_group.lambda_logs[0].arn : null
}

output "alias_names" {
  description = "Names of the Lambda aliases"
  value       = keys(aws_lambda_alias.this)
}

output "alias_arns" {
  description = "ARNs of the Lambda aliases"
  value       = { for k, v in aws_lambda_alias.this : k => v.arn }
}
