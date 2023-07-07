# backend
terraform {
  backend "local" {}
  required_version = "1.5.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.7.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.4.0"
    }
  }
}

# provider
provider "aws" {
  region = "us-east-1"

  access_key = "mock_access_key"
  secret_key = "mock_secret_key"

  #s3_force_path_style         = true # removed https://github.com/hashicorp/terraform-provider-aws/pull/31155
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    iam         = "${var.endpoint}"
    kinesis     = "${var.endpoint}"
    lambda      = "${var.endpoint}"
    s3          = "${var.endpoint}"
    apigateway  = "${var.endpoint}"
  }
}
