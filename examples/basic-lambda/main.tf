// examples/basic-lambda/main.tf

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "lambda_deployment_bucket" {
  bucket = "${var.project_name}-lambda-deployments-${var.environment}"
  acl    = "private"

  tags = merge(var.tags, {
    Name = "${var.project_name}-lambda-deployments-${var.environment}"
  })
}

resource "aws_s3_bucket_object" "lambda_deployment_package" {
  bucket = aws_s3_bucket.lambda_deployment_bucket.id
  key    = "lambda_function.zip"
  source = "./lambda_function.zip"
  etag   = filemd5("./lambda_function.zip")
}

module "lambda_function" {
  source = "../../"

  project_name = var.project_name
  environment  = var.environment

  function_name = "my-example-function"
  filename      = aws_s3_bucket_object.lambda_deployment_package.id
  handler       = "index.handler"
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 30

  tags = var.tags
}
