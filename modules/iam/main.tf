# Lambda Assume Role Policy Document
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name        = "${var.project_name}-${var.environment}-lambda-role"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Lambda Basic Execution Policy (CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 Access Policy Document
data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${var.raw_data_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${var.processed_data_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      var.raw_data_bucket.arn,
      var.processed_data_bucket.arn
    ]
  }
}

# S3 Access Policy
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.project_name}-${var.environment}-s3-access-policy"
  description = "Policy for Lambda to access S3 buckets"
  policy      = data.aws_iam_policy_document.s3_access.json
}

# Attach S3 Access Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# CloudWatch Logs Policy Document
data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      var.cloudwatch_log_group.arn
    ]
  }
}

# CloudWatch Logs Policy
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.project_name}-${var.environment}-cloudwatch-logs-policy"
  description = "Policy for Lambda to write to CloudWatch Logs"
  policy      = data.aws_iam_policy_document.cloudwatch_logs.json
}

# Attach CloudWatch Logs Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# KMS Access Policy Document
data "aws_iam_policy_document" "kms_access" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = [
      var.kms_key_arn
    ]
  }
}

# KMS Access Policy
resource "aws_iam_policy" "kms_access_policy" {
  name        = "${var.project_name}-${var.environment}-kms-access-policy"
  description = "Policy for Lambda to access KMS key for S3 encryption"
  policy      = data.aws_iam_policy_document.kms_access.json
}

# Attach KMS Access Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_kms_access" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.kms_access_policy.arn
}
