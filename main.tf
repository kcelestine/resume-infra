terraform {
  cloud {
    organization = "_cloudcte"

    workspaces {
      name = "api"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket-1" {
  bucket = "www.${var.bucket_name}"
}

data "aws_s3_bucket" "selected-bucket" {
  bucket = aws_s3_bucket.bucket-1.bucket
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = data.aws_s3_bucket.selected-bucket.bucket
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = data.aws_s3_bucket.selected-bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      data.aws_s3_bucket.selected-bucket.arn,
      "${data.aws_s3_bucket.selected-bucket.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_file" {
  type        = "zip"
  source_file = "default-lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_api_gateway_rest_api" "resume_api_gateway" {
  name = "Resume API Gateway"
}

resource "aws_api_gateway_resource" "countResource" {
  rest_api_id = aws_api_gateway_rest_api.resume_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.resume_api_gateway.root_resource_id # In this case, the parent id should the gateway root_resource_id.
  path_part   = "count"
}

resource "aws_api_gateway_method" "postCount" {
  rest_api_id   = aws_api_gateway_rest_api.resume_api_gateway.id
  resource_id   = aws_api_gateway_resource.countResource.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.resume_api_gateway.id
  resource_id             = aws_api_gateway_resource.countResource.id
  http_method             = aws_api_gateway_method.postCount.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_integration.integration"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.resume_api_gateway.id}"
  stage_name  = "test"
}
