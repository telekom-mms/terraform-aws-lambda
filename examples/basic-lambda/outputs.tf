// examples/basic-lambda/outputs.tf

output "function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda_function.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda_function.function_arn
}
