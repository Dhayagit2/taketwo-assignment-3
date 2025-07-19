provider "aws" {
  region = "ap-south-1"
}

# S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-take-two"
  force_destroy = true
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "example-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach basic logging policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "example" {
  function_name = "example-lambda"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_exec.arn

  filename         = "${path.module}/lambda.zip"                  # Uses local path inside infra/
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      LOG_LEVEL = "info"
    }
  }
}
