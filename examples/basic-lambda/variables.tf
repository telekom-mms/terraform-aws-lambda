// examples/basic-lambda/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "example-lambda"
}

variable "environment" {
  description = "Environment (e.g., prod, dev, test)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "terraform"
    Project     = "lambda-example"
  }
}
