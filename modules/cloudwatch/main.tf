# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-data-processor"
  retention_in_days = 14
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.project_name}-${var.environment}-lambda-logs"
    Environment = var.environment
    Project     = var.project_name
  }
}
