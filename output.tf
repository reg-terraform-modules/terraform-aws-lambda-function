output "arn" {
  description = "Lambda arn"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Lambda arn"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.this.function_name
}