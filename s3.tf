# S3 Event Notification for Lambda Trigger
# Using data source to avoid circular dependency
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = module.s3_buckets.raw_data_bucket.id

  lambda_function {
    lambda_function_arn = data.aws_lambda_function.data_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ".json"
  }

  depends_on = [
    module.s3_buckets.raw_data_bucket,
    module.s3_buckets.processed_data_bucket,
    module.lambda.lambda_function,
    module.iam.lambda_role
  ]
}


# Upload sample data to raw data bucket, wait for dependencies to be met
resource "aws_s3_object" "sample_data" {
  bucket = module.s3_buckets.raw_data_bucket.id
  key    = "ikerian_sample.json"
  source = local.data_file
  etag   = filemd5(local.data_file)

  depends_on = [
    module.s3_buckets.raw_data_bucket,
    module.s3_buckets.processed_data_bucket,
    module.lambda.lambda_function,  # This ensures Lambda is created first
    module.lambda.lambda_permission # This ensures permissions are set
  ]

  tags = {
    Name        = "ikerian-sample-data"
    Environment = var.environment
    Project     = var.project_name
  }
}
