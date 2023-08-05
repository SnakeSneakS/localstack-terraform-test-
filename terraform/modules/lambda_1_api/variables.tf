variable "ami_id" {
  type = string
  default = "version1"
  description = "when this value changes, random value changes"
}

variable "prefix" {
  type        = string
  default     = "app"
  description = "prefix"
}



# lambda
variable "lambda_source_file" {
  type        = string
  description = "lambda source file"
}

variable "lambda_output_file" {
  type        = string
  description = "zip file created from lambda_source_file"
}

variable "lambda_handler" {
  type  = string
}

variable "lambda_env_vars" {
  #type = object
  default = {target = "world"}
}

# api gateway
variable "stage" {
  type        = string
  default     = "test"
}

variable "api_gw_rest" {
  type  = object({
    id = string
    execution_arn = string
  })
  default = null
}

variable "api_gw_resource_parent_id" {
  type  = string
  default = null
  description = "if this value is set, api_gateway resource is added to this rest resource"
}

variable "api_gw_method" {
  type = string
  default = "ANY"
}

variable "api_gw_authorization" {
  type  = string
  default = "NONE"
}

variable "api_path" {
  type = string
  default = "api"
}
