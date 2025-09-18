output "kms_key" {
  description = "The globally unique identifier for the KMS key"
  value       = aws_kms_key.s3_encryption
}

# output "kms_key_arn" {
#   description = "The Amazon Resource Name (ARN) of the KMS key"
#   value       = aws_kms_key.s3_encryption.arn
# }

# output "kms_alias_name" {
#   description = "The display name of the KMS key alias"
#   value       = aws_kms_alias.s3_encryption.name
# }
