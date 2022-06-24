# Resource/function: lambda function

## Purpose
Generic code for generating lambda executable including generation of script package.

## Description
Establishes a lambda executable using standardized naming and input, including generation of script package from folder. 

## Terraform functions

### Data sources
- `archive_file`
    - generates .zip file from folder

### Resources
- `local_file`
    - copies file from any location into .zip source folder
- `aws_lambda_function` 
    - establishes lambda function 

## Input variables
### Required
- `parent_module_path`
    - path of the module that calls this resource/function
- `iam_role_arn`
    - arn of iam role to be used by lambda script
- `lambda_script_source_dir`
    - path to folder containing all files to be uploaded in .zip
- `lambda_script_output_path`
    - path where .zip file will be stored locally
- `lambda_handler`
    - execution handler used to invoke lambda
- `module_name`
    - name of child module - used to create resource name

### Optional (default values used unless specified)
- `lambda_runtime`
    - Runtime environment to be used when executing lambda
    - default: `python3.7`
- `description`
    - description of role
    - default: `No description given`
- `timeout`
    - Timeout limitation for execution of scripts, in seconds
    - default: `3`
- `lambda_environment_variables`
    - Environment variables available when executing lambda
    - default: `"env_var" = "none given"`
- `resource_tags`
    - tags added to lambda - should be specified jointly with all other resources in the same module
    - default: `"tag" = "none given"`
- `additional_file_include`
    - option to include script file from other location than `lambda_script_source_dir`. Accepts `true` or `false`.
    - default: `false`
- `additional_file_path`
    - path to additional file
    - default: `./`
- `additional_file_target`
    - target location for additional file. Must be inside `lambda_script_source_dir`. 
    - default: `./`
- `layer_names`
    - arn of layers to be connected to lambda function
    - must be given as a list using `[ ]`
    - default: `[]`
- `lambda_url_resource`
    - option to make lambda function as a URL resource. Makes it a dedicated HTTP(S) endpoint. Accepts `true` or `false`.
    - default: `false`
- `allow_methods_url`
    - option for HTTP methods that are allowed when calling the function URL. For example: ["GET", "POST", "DELETE"]. Only used when "lambda_url_resource" = "true"
    - default: `["POST"]`
- `allow_origins_url`
    - option for origins that can access the function URL. For example: ["https://www.example.com", "http://localhost:60905"]. Only used when "lambda_url_resource" = "true"
    - default: `["*"]`

## Output variables
- `arn`
    - `arn` of the lambda function
- `invoke_arn`
    - `arn` needed to invoke lambda from other resources
- `function_name`
    - name of the lambda function

## Example use
The below example generates a lambda functin as a module using the terraform scripts from `source`. The `iam_role_arn` connects lambda to the role needed to execute the script. 

The script generates a `.zip` package containing scripts located in `lambda_script_source_dir`. With the `additional_file_include = true`, an additional file is copied into `lambda_script_source_dir` before generating `.zip`. An alternative, or used in combination, is the layer arns which makes a layer available to the lambda function.

```sql
module "lambda_download_to_s3" {
  source                        = "app.terraform.io/renovasjonsetaten/lambda-function/aws"
  version                       = "0.0.5"
  env                           = var.env
  parent_module_path            = path.module
  iam_role_arn                  = module.iam_role_for_lambda.arn
  lambda_script_source_dir      = join("", [path.module, "/lambda_download_to_s3"])
  lambda_script_output_path     = join("", [path.module, "/zip_package/"])
  lambda_handler                = "main.run"
  resource_tags                 = var.resource_tags
  additional_file_include       = true
  additional_file_path          = "./library/lambda/ssm_secret.py"
  additional_file_target        = "ssm_secret.py"
  module_name                   = "lambda_download_to_s3"
  timeout                       = 30
  lambda_url_resource           = var.lambda_url_resource
  lambda_environment_variables  = merge(    
                {"bucket" = var.bucket},
                {"target_prefix" = var.target_prefix}
                )
  
  layer_names                   = var.layer_names
}
```

## Further work
