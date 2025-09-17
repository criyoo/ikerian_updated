# Raw Data & Processed Data Buckets
# checkov:skip=CKV2_AWS_61:Ensure that an S3 bucket has a lifecycle configuration
resource "aws_s3_bucket" "main" {
  for_each = {
    raw_data_bucket       = "${var.project_name}-${var.environment}-raw-data-"
    processed_data_bucket = "${var.project_name}-${var.environment}-processed-data-"
  }

  bucket_prefix = each.value

  tags = {
    Name        = each.key
    Environment = var.environment
    Project     = var.project_name
  }
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Logging
resource "aws_s3_bucket_logging" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "access-logs/${each.key}/"
}


# Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  for_each = aws_s3_bucket.main

  bucket = each.value.id

  rule {
    id     = "${each.key}_lifecycle"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}



# Logging Bucket
# checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
resource "aws_s3_bucket" "logging_bucket" {
  bucket_prefix = "${var.project_name}-${var.environment}-access-logs-"

  tags = {
    Name        = "access-logs-bucket"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "S3 access logging"
  }
}

# # Logging Bucket Versioning
# resource "aws_s3_bucket_versioning" "logging_bucket" {
#   bucket = aws_s3_bucket.logging_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Logging Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# Logging Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Logging Bucket Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    id     = "logging_bucket_lifecycle"
    status = "Enabled"

    filter {}

    expiration {
      days = 90
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

