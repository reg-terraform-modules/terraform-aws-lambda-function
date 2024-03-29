resource "local_file" "additional_file" {
  count    = var.additional_file_include ? 1 : 0
  filename = join("", [var.lambda_script_source_dir, "/", var.additional_file_target])
  content  = file(var.additional_file_path)
}

data "archive_file" "this" {
  count       = var.additional_file_include ? 0 : 1
  type        = "zip"
  output_path = join("", [var.lambda_script_output_path, "file1.zip"])
  source_dir  = var.lambda_script_source_dir
}

data "archive_file" "that" {
  count       = var.additional_file_include ? 1 : 0
  type        = "zip"
  output_path = join("", [var.lambda_script_output_path, "file2.zip"])
  source_dir  = var.lambda_script_source_dir
  depends_on = [
    local_file.additional_file,
  ]
}

resource "local_file" "second_additional_file" {
  count    = var.second_additional_file_include ? 1 : 0
  filename = join("", [var.lambda_script_source_dir, "/", var.second_additional_file_target])
  content  = file(var.second_additional_file_path)
}

data "archive_file" "second_this" {
  count       = var.second_additional_file_include ? 0 : 1
  type        = "zip"
  output_path = join("", [var.lambda_script_output_path, "sec_file1.zip"])
  source_dir  = var.lambda_script_source_dir
}

data "archive_file" "second_that" {
  count       = var.second_additional_file_include ? 1 : 0
  type        = "zip"
  output_path = join("", [var.lambda_script_output_path, "sec_file2.zip"])
  source_dir  = var.lambda_script_source_dir
  depends_on = [
    local_file.second_additional_file,
  ]
}

resource "aws_lambda_function" "this" {
  filename         = join("", [var.lambda_script_output_path, "file1.zip"])
  function_name    = var.name
  role             = var.iam_role_arn
  handler          = var.lambda_handler
  source_code_hash = filebase64sha256(join("", [var.lambda_script_output_path, "file1.zip"]))
  runtime          = var.lambda_runtime
  description      = var.description
  timeout          = var.timeout
  memory_size      = var.memory_size
  environment {
    variables = var.lambda_environment_variables
  }
  layers  = var.layer_names
  tags    = var.resource_tags
  publish = var.publish
}

resource "aws_lambda_function_url" "test_live" {
  count              = var.lambda_url_resource ? 1 : 0
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = var.allow_origins_url
    allow_methods     = var.allow_methods_url
  }
}
