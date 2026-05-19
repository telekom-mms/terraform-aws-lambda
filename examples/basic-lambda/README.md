# AWS Lambda Basic Example

This example demonstrates how to use the AWS Lambda module to create a basic Lambda function.

## Features

- Basic Lambda function deployment
- Python 3.9 runtime
- S3 bucket for deployment package

## Usage

1.  Create a `lambda_function.zip` file in the `examples/basic-lambda/` directory. This zip file should contain your Lambda code (e.g., `index.py` with a `handler` function).
2.  Copy this example to your project.
3.  Update `variables.tf` with your specific values.
4.  Initialize and apply:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

## Variables

See `variables.tf` for all configurable options.

## Outputs

- `function_name`: Name of the created Lambda function.
- `function_arn`: ARN of the created Lambda function.

## Requirements

- AWS CLI configured
- Terraform >= 1.0
- A `lambda_function.zip` file containing your Lambda code.
