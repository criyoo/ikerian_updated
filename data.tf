# Data source to reference the Lambda function after it's created
data "aws_lambda_function" "data_processor" {
  function_name = "${var.project_name}-${var.environment}-data-processor"

  depends_on = [module.lambda.lambda_function]
}
