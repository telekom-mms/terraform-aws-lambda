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
