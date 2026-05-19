<!-- BEGIN_TF_DOCS -->


## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

## Resources

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint in your code | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime | `string` | n/a | yes |
| <a name="input_allow_public_function_url"></a> [allow\_public\_function\_url](#input\_allow\_public\_function\_url) | Explicit opt-in required to create a public (unauthenticated) function URL | `bool` | `false` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function (x86\_64 or arm64) | `list(string)` | <pre>[<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | Whether to create the CloudWatch log group for the Lambda function | `bool` | `true` | no |
| <a name="input_custom_iam_policy"></a> [custom\_iam\_policy](#input\_custom\_iam\_policy) | JSON-formatted custom IAM policy to attach to the Lambda role | `string` | `""` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | Dead letter queue configuration | <pre>object({<br/>    target_arn = string<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does | `string` | `""` | no |
| <a name="input_enable_function_url"></a> [enable\_function\_url](#input\_enable\_function\_url) | Whether to create a Lambda function URL | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables that are accessible from the function code during execution | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB | `number` | `512` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function (if empty, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_function_url_auth_type"></a> [function\_url\_auth\_type](#input\_function\_url\_auth\_type) | The type of authentication that your function URL uses (NONE or AWS\_IAM) | `string` | `"AWS_IAM"` | no |
| <a name="input_function_url_cors"></a> [function\_url\_cors](#input\_function\_url\_cors) | CORS configuration for the Lambda function URL | <pre>object({<br/>    allow_credentials = optional(bool)<br/>    allow_headers     = optional(list(string))<br/>    allow_methods     = optional(list(string))<br/>    allow_origins     = optional(list(string))<br/>    expose_headers    = optional(list(string))<br/>    max_age           = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | List of IAM policy ARNs to attach to the Lambda role | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt your function's environment variables | `string` | `""` | no |
| <a name="input_lambda_aliases"></a> [lambda\_aliases](#input\_lambda\_aliases) | Map of Lambda aliases to create | <pre>map(object({<br/>    description      = optional(string)<br/>    function_version = string<br/>  }))</pre> | `{}` | no |
| <a name="input_lambda_permissions"></a> [lambda\_permissions](#input\_lambda\_permissions) | Map of Lambda permissions to create | <pre>map(object({<br/>    statement_id = string<br/>    action       = string<br/>    principal    = string<br/>    source_arn   = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_log_group_kms_key_arn"></a> [log\_group\_kms\_key\_arn](#input\_log\_group\_kms\_key\_arn) | The ARN of the KMS Key to use when encrypting log data | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names (if not provided, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `-1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN attached to the Lambda Function. If provided, the module will not create a role. | `string` | `""` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket location containing the function's deployment package | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 key of the function's deployment package | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | Object version ID of the function's deployment package | `string` | `null` | no |
| <a name="input_snap_start"></a> [snap\_start](#input\_snap\_start) | Whether to enable SnapStart for the function (only supported for Java runtimes) | `bool` | `false` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Used to trigger updates when your local objects change | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Amount of time your Lambda Function has to run in seconds | `number` | `3` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Whether to sample and trace a subset of incoming requests with AWS X-Ray (PassThrough or Active) | `string` | `"Active"` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Provide this to allow your function to access your VPC | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arns"></a> [alias\_arns](#output\_alias\_arns) | ARNs of the Lambda aliases |
| <a name="output_alias_names"></a> [alias\_names](#output\_alias\_names) | Names of the Lambda aliases |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of the Lambda function |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | Invoke ARN of the Lambda function |
| <a name="output_function_last_modified"></a> [function\_last\_modified](#output\_function\_last\_modified) | Date this resource was last modified |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_function_qualified_arn"></a> [function\_qualified\_arn](#output\_function\_qualified\_arn) | Qualified ARN of the Lambda function |
| <a name="output_function_source_code_hash"></a> [function\_source\_code\_hash](#output\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_function_source_code_size"></a> [function\_source\_code\_size](#output\_function\_source\_code\_size) | Size in bytes of the function .zip file |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | URL of the Lambda function (if enabled) |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | Version of the Lambda function |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of the CloudWatch log group |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | Name of the CloudWatch log group |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role used by the Lambda function |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role used by the Lambda function |
<!-- END_TF_DOCS -->