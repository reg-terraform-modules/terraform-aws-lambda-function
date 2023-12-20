# Required variables:
variable "name" {
  description = "Lambda function name"
  type        = string
}

variable "iam_role_arn" {
  description = "Arn of generated role"
  type        = string
}

variable "lambda_script_source_dir" {
  description = "Directory of lambda package source"
  type        = string
}

variable "lambda_script_output_path" {
  description = "Path to zipped lambda package"
  type        = string
}

variable "lambda_handler" {
  description = "Handler used by lambda to execute script"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime environment to be used when executing lambda. Non-optional because runtime should be explicitly defined."
  type        = string
}

#Optional variables - default values used unless others specified:
variable "description" {
  description = "Description of what lambda function does"
  type        = string
  default     = "No description given"
}

variable "timeout" {
  description = "Timeout limitation for execution of scripts"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Memory allocated to scripts - in increments of 64 MB from 128."
  type        = number
  default     = 128
}

variable "lambda_environment_variables" {
  description = "Defaults to no env variables. If needed, env vars can be given in parent module variables.tf, and assigned in child module call"
  type        = map(string)
  default = {
    "env_var" = "none given"
  }
}

variable "resource_tags" {
  description = "Defaults to no tags. If needed, env vars can be given in parent module variables.tf, and assigned in child module call"
  type        = map(string)
  default = {
    "tag" = "none given"
  }
}

variable "additional_file_include" {
  description = "option to include script file from other location"
  type = string
  default = false
}

variable "additional_file_path" {
  description = "path to additional file"
  type = string
  default = "./"
}

variable "additional_file_target" {
  description = "target location for additional file."
  type = string
  default = "./"
}

variable "second_additional_file_include" {
  description = "option to include script file from other location"
  type = string
  default = false
}

variable "second_additional_file_path" {
  description = "path to additional file"
  type = string
  default = "./"
}

variable "second_additional_file_target" {
  description = "target location for additional file."
  type = string
  default = "./"
}

variable "layer_names" {
  type        = list(string)
  default     = []
}

variable "publish" {
  description = "Boolean for publishing lambda function version"
  type = bool
  default = false
}

variable "lambda_url_resource" {
  description = "Boolean for making lambda a function URL endpoint"
  type = bool
  default = false
}

variable "allow_methods_url" {
  description = "function allowed for URL endpoint"
  type = list(string)
  default = [ "POST" ]
}

variable "allow_origins_url" {
  description = "origins allowed to use method for URL endpoint"
  type = list(string)
  default = [ "*" ]
}
