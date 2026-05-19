// variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names (if not provided, will use project-environment pattern)"
  type        = string
  default     = ""
}


variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}

variable "function_name" {
  description = "Name of the Lambda function (if empty, will use project-environment pattern)"
  type        = string
  default     = ""
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the function's deployment package"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version ID of the function's deployment package"
  type        = string
  default     = null
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = string
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function (x86_64 or arm64)"
  type        = list(string)
  default     = ["arm64"] # Best practice: arm64 is usually better price/performance
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 3
}

variable "description" {
  description = "Description of what your Lambda Function does"
  type        = string
  default     = ""
}

variable "role_arn" {
  description = "IAM role ARN attached to the Lambda Function. If provided, the module will not create a role."
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt your function's environment variables"
  type        = string
  default     = ""
}

variable "vpc_config" {
  description = "Provide this to allow your function to access your VPC"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "dead_letter_config" {
  description = "Dead letter queue configuration"
  type = object({
    target_arn = string
  })
  default = null
}

variable "tracing_mode" {
  description = "Whether to sample and trace a subset of incoming requests with AWS X-Ray (PassThrough or Active)"
  type        = string
  default     = "Active" # Best practice: enable tracing by default
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  type        = number
  default     = -1
}

variable "source_code_hash" {
  description = "Used to trigger updates when your local objects change"
  type        = string
  default     = ""
}

variable "create_log_group" {
  description = "Whether to create the CloudWatch log group for the Lambda function"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 30
}

variable "log_group_kms_key_arn" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = ""
}

variable "enable_function_url" {
  description = "Whether to create a Lambda function URL"
  type        = bool
  default     = false
}

variable "function_url_auth_type" {
  description = "The type of authentication that your function URL uses (NONE or AWS_IAM)"
  type        = string
  default     = "AWS_IAM" # Security first: default to IAM
}

variable "function_url_cors" {
  description = "CORS configuration for the Lambda function URL"
  type = object({
    allow_credentials = optional(bool)
    allow_headers     = optional(list(string))
    allow_methods     = optional(list(string))
    allow_origins     = optional(list(string))
    expose_headers    = optional(list(string))
    max_age           = optional(number)
  })
  default = null
}

variable "lambda_permissions" {
  description = "Map of Lambda permissions to create"
  type = map(object({
    statement_id = string
    action       = string
    principal    = string
    source_arn   = optional(string)
  }))
  default = {}
}

variable "lambda_aliases" {
  description = "Map of Lambda aliases to create"
  type = map(object({
    description      = optional(string)
    function_version = string
  }))
  default = {}
}

variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}

variable "custom_iam_policy" {
  description = "JSON-formatted custom IAM policy to attach to the Lambda role"
  type        = string
  default     = ""
}

variable "ephemeral_storage_size" {
  description = "The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB"
  type        = number
  default     = 512
}

variable "snap_start" {
  description = "Whether to enable SnapStart for the function (only supported for Java runtimes)"
  type        = bool
  default     = false
}
