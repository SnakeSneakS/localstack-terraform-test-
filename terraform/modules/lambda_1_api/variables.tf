variable "stage" {
  type        = string
  default     = "test"
}

variable "prefix" {
  type        = string
  default     = "app"
  description = "prefix"
}

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

variable "api_path" {
  type = string
  default = "api"
}

variable "ami_id" {
  type = string
  default = "version1"
  description = "when this value changes, random value changes"
}