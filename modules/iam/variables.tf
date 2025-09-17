variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Name of the Environment"
  type        = string
}

variable "raw_data_bucket" {
  description = "ARN of the raw data bucket"
  type        = any
}

variable "processed_data_bucket" {
  description = "ARN of the processed data bucket"
  type        = any
}

variable "cloudwatch_log_group" {
  description = "ARN of the CloudWatch log group"
  type        = any
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for S3 encryption"
  type        = string
}
