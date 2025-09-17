# KMS Key for S3 encryption
resource "aws_kms_key" "s3_encryption" {
  description             = "KMS key for S3 bucket encryption - ${var.project_name}-${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-s3-encryption-key"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "S3 encryption"
  }
}

# KMS Key Alias
resource "aws_kms_alias" "s3_encryption" {
  name          = "alias/${var.project_name}-${var.environment}-s3-encryption"
  target_key_id = aws_kms_key.s3_encryption.key_id
}

# KMS Key Policy
resource "aws_kms_key_policy" "s3_encryption" {
  key_id = aws_kms_key.s3_encryption.id
  policy = data.aws_iam_policy_document.kms_key_policy.json
}

# KMS Key Policy Document
data "aws_iam_policy_document" "kms_key_policy" {
  # Allow the root account to manage the key
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Allow S3 service to use the key for encryption/decryption
  statement {
    sid    = "Allow S3 service to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  # Allow Lambda service to use the key for encryption/decryption
  statement {
    sid    = "Allow Lambda service to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  # Allow any principal in the account to use the key (will be restricted by IAM policies)
  statement {
    sid    = "Allow account principals to use the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
