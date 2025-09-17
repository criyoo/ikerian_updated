
# KMS Key for S3 encryption
module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
  environment  = var.environment
}

# IAM Roles and Policies (without KMS initially)
module "iam" {
  source = "./modules/iam"

  project_name          = var.project_name
  environment           = var.environment
  raw_data_bucket       = module.s3_buckets.raw_data_bucket
  processed_data_bucket = module.s3_buckets.processed_data_bucket
  cloudwatch_log_group  = module.cloudwatch.cloudwatch_log_group
  kms_key_arn           = module.kms.kms_key_arn
}

# S3 Buckets
module "s3_buckets" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
  kms_key_id   = module.kms.kms_key_id
}

# Lambda Function
module "lambda" {
  source = "./modules/lambda"

  project_name          = var.project_name
  environment           = var.environment
  lambda_role_arn       = module.iam.lambda_role.arn
  raw_data_bucket       = module.s3_buckets.raw_data_bucket
  processed_data_bucket = module.s3_buckets.processed_data_bucket

}

# CloudWatch Log Group for Lambda
module "cloudwatch" {
  source = "./modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment
  kms_key_id   = module.kms.kms_key_id
}
