<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]

<br />

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/telekom-mms/terraform-aws-lambda">
    <img src="logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">AWS Lambda Module</h3>

  <p align="center">
    PSA-compliant AWS Lambda module with VPC integration, X-Ray tracing, and secure logging.
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-lambda"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-lambda">View Demo</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-lambda/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-lambda/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

## Documentation

Full auto-generated documentation of inputs, outputs, and resources: [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md)

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#features">Features</a></li>
        <li><a href="#opentofu-compatibility">OpenTofu Compatibility</a></li>
        <li><a href="#psa-compliance">PSA Compliance</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#environment-files">Environment Files</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#security-features">Security Features</a></li>
    <li><a href="#outputs">Outputs</a></li>
    <li><a href="#psa-compliance-features">PSA Compliance Features</a></li>
    <li><a href="#integration">Integration</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This Terraform module creates PSA-compliant AWS Lambda functions with mandatory VPC support options, encrypted environment variables, and integrated monitoring. It is designed to simplify serverless deployments while strictly adhering to security best practices.

### Features

- **ARM64 Architecture**: Defaulted to `arm64` (Graviton2) for better price/performance.
- **VPC Integration**: Easy configuration for private subnet execution.
- **KMS Encryption**: Dedicated key support for encrypting environment variables and logs.
- **Dead Letter Queues**: Native DLQ support for asynchronous failure handling.
- **X-Ray Tracing**: `Active` tracing enabled by default.
- **Function URLs**: Secure Function URL creation with `AWS_IAM` authentication by default.
- **Concurrency Control**: Reserved concurrency settings to prevent runaway scaling.
- **SnapStart**: Java SnapStart support for reduced cold starts.

### OpenTofu Compatibility

This module is designed to work with both Terraform and OpenTofu. The module uses standard HCL syntax that is compatible with both tools, ensuring seamless integration regardless of which infrastructure-as-code tool you choose.

### PSA Compliance

PSA compliance is an internal best practice that is automatically enforced by this module. All resources created by this module automatically adhere to PSA compliance standards (e.g., Req 3.66-05 for logging, Req 3.50-01 for encryption) without requiring any additional configuration.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

- Terraform v1.3 or higher
- AWS CLI configured with appropriate permissions

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/telekom-mms/terraform-aws-lambda.git
   ```
2. Navigate to the module directory
   ```sh
   cd terraform-aws-lambda
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

This module can be used with or without environment files. Below are examples of both approaches.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ENVIRONMENT FILES -->
## Environment Files

The module supports environment-specific configuration through external environment files.

1. **Template File**: A template file `env-template.tfvars` is provided in the `env/` directory.
2. **Creating Environment Files**: Copy `env-template.tfvars` to `env/env-<environment>.tfvars`.
3. **Using Environment Files**: Specify the environment file via the `-var-file` parameter.

```hcl
module "lambda" {
  source = "./terraform-aws-lambda"

  # Required variables
  project_name = "myapp"
  environment  = "prod"
  
  function_name = "core-processor"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename      = "./build/function.zip"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- EXAMPLES -->
## Examples

### Basic Usage

```hcl
module "lambda" {
  source = "./terraform-aws-lambda"

  project_name = "demo"
  environment  = "dev"
  
  function_name = "hello-world"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "function.zip"
  
  environment_variables = {
    FOO = "bar"
  }
}
```

### Advanced Usage with VPC and DLQ

```hcl
module "lambda" {
  source = "./terraform-aws-lambda"

  project_name = "secure-processor"
  environment  = "prod"
  
  function_name = "data-processor"
  handler       = "main.go"
  runtime       = "go1.x"
  s3_bucket     = "my-deploy-bucket"
  s3_key        = "v1.0.0/function.zip"
  
  # VPC Configuration
  vpc_config = {
    subnet_ids         = ["subnet-private-1", "subnet-private-2"]
    security_group_ids = ["sg-lambda-access"]
  }
  
  # Failure Handling
  dead_letter_config = {
    target_arn = "arn:aws:sqs:region:account:queue/dlq"
  }
  
  # Security
  kms_key_arn = "arn:aws:kms:region:account:key/..."
  reserved_concurrent_executions = 50
  
  tags = {
    Owner = "data-team"
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `function_arn` | ARN of the Lambda function |
| `function_invoke_arn` | Invoke ARN for API Gateway integration |
| `function_name` | Name of the function |
| `role_arn` | ARN of the IAM execution role |
| `function_url` | The HTTP URL endpoint (if enabled) |
| `log_group_arn` | ARN of the CloudWatch log group |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SECURITY FEATURES -->
## Security Features

- **Least Privilege**: IAM roles created with minimal required permissions (Basic Execution + VPC Access only if enabled).
- **Environment Encryption**: Mandatory support for KMS keys to encrypt environment variables.
- **Secure Logs**: CloudWatch Logs groups encrypted with KMS and set with strict retention policies.
- **VPC Isolation**: Easy integration with private subnets to keep traffic off the public internet.
- **Tracing**: Active X-Ray tracing for deep visibility into execution paths.
- **AuthN/AuthZ**: Function URLs default to `AWS_IAM` auth type to prevent public exposure.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- PSA COMPLIANCE FEATURES -->
## PSA Compliance Features

This module implements the following PSA compliance features (referencing `03-Strukturierte_PSA_Anforderungen_Systeme_LLM.pdf` and `04-Strukturierte_PSA_Anforderungen_Orchestrator_Microservice_LLM.pdf`):

### Security Controls

- **Req 3.66-05 (Logging)**: CloudWatch Log Group creation is mandatory and customizable.
- **Req 3.50-01 (Encryption)**: KMS support for environment variables and logs.
- **Req 3.01-06 (Access Control)**: IAM authentication enforced for Function URLs.
- **Req 8 (Network Policies)**: Support for VPC execution to respect network segmentation.
- **Req 9 (Audit Logging)**: Integrated with CloudWatch and X-Ray for full auditability.

### Operational Excellence

- **Concurrency**: `reserved_concurrent_executions` variable to prevent "Noisy Neighbor" issues and DoS.
- **Architectures**: Default `arm64` for cost/performance optimization.
- **Updates**: Support for `source_code_hash` to ensure atomic deployments.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- INTEGRATION -->
## Integration

### Related Modules

- [terraform-aws-vpc](../terraform-aws-vpc) - Network foundation
- [terraform-aws-iam-roles](../terraform-aws-iam-roles) - Advanced role management
- [terraform-aws-sns](../terraform-aws-sns) - Event triggers
- [terraform-aws-sqs](../terraform-aws-sqs) - Dead letter queues

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- TROUBLESHOOTING -->
## Troubleshooting

### Function Timeout

- Increase the `timeout` variable (default 3s).
- Check VPC network connectivity (NAT Gateway) if accessing internet resources.

### Permission Denied (KMS)

- Ensure the Lambda execution role is a key user in the KMS key policy.
- Verify the `kms_key_arn` is correct and in the same region.

### VPC ENI Issues

- Ensure the subnets have enough available IP addresses.
- Verify the security group allows outbound traffic.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the Mozilla Public License Version 2.0. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Project Link: [https://github.com/telekom-mms/terraform-aws-lambda](https://github.com/telekom-mms/terraform-aws-lambda)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/telekom-mms/terraform-aws-lambda.svg?style=for-the-badge
[contributors-url]: https://github.com/telekom-mms/terraform-aws-lambda/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/telekom-mms/terraform-aws-lambda.svg?style=for-the-badge
[forks-url]: https://github.com/telekom-mms/terraform-aws-lambda/network/members
[stars-shield]: https://img.shields.io/github/stars/telekom-mms/terraform-aws-lambda.svg?style=for-the-badge
[stars-url]: https://github.com/telekom-mms/terraform-aws-lambda/stargazers
[issues-shield]: https://img.shields.io/github/issues/telekom-mms/terraform-aws-lambda.svg?style=for-the-badge
[issues-url]: https://github.com/telekom-mms/terraform-aws-lambda/issues
[license-shield]: https://img.shields.io/github/license/telekom-mms/terraform-aws-lambda.svg?style=for-the-badge
[license-url]: https://github.com/telekom-mms/terraform-aws-lambda/blob/master/LICENSE.txt

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_public_function_url"></a> [allow\_public\_function\_url](#input\_allow\_public\_function\_url) | Explicit opt-in required to create a public (unauthenticated) function URL | `bool` | `false` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function (x86\_64 or arm64) | `list(string)` | <pre>[<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | Whether to create the CloudWatch log group for the Lambda function | `bool` | `true` | no |
| <a name="input_custom_iam_policy"></a> [custom\_iam\_policy](#input\_custom\_iam\_policy) | JSON-formatted custom IAM policy to attach to the Lambda role | `string` | `""` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | Dead letter queue configuration | <pre>object({<br/>    target_arn = string<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does | `string` | `""` | no |
| <a name="input_enable_function_url"></a> [enable\_function\_url](#input\_enable\_function\_url) | Whether to create a Lambda function URL | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g., prod, dev, test) | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables that are accessible from the function code during execution | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB | `number` | `512` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package within the local filesystem | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function (if empty, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_function_url_auth_type"></a> [function\_url\_auth\_type](#input\_function\_url\_auth\_type) | The type of authentication that your function URL uses (NONE or AWS\_IAM) | `string` | `"AWS_IAM"` | no |
| <a name="input_function_url_cors"></a> [function\_url\_cors](#input\_function\_url\_cors) | CORS configuration for the Lambda function URL | <pre>object({<br/>    allow_credentials = optional(bool)<br/>    allow_headers     = optional(list(string))<br/>    allow_methods     = optional(list(string))<br/>    allow_origins     = optional(list(string))<br/>    expose_headers    = optional(list(string))<br/>    max_age           = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint in your code | `string` | n/a | yes |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | List of IAM policy ARNs to attach to the Lambda role | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt your function's environment variables | `string` | `""` | no |
| <a name="input_lambda_aliases"></a> [lambda\_aliases](#input\_lambda\_aliases) | Map of Lambda aliases to create | <pre>map(object({<br/>    description      = optional(string)<br/>    function_version = string<br/>  }))</pre> | `{}` | no |
| <a name="input_lambda_permissions"></a> [lambda\_permissions](#input\_lambda\_permissions) | Map of Lambda permissions to create | <pre>map(object({<br/>    statement_id = string<br/>    action       = string<br/>    principal    = string<br/>    source_arn   = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_log_group_kms_key_arn"></a> [log\_group\_kms\_key\_arn](#input\_log\_group\_kms\_key\_arn) | The ARN of the KMS Key to use when encrypting log data | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Specifies the number of days you want to retain log events in the specified log group | `number` | `30` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names (if not provided, will use project-environment pattern) | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. | `number` | `-1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN attached to the Lambda Function. If provided, the module will not create a role. | `string` | `""` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime | `string` | n/a | yes |
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