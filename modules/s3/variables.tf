variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Name of Environment"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for S3 bucket encryption"
  type        = string
}


