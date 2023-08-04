module "lambda_1_api" {
    source = "../../modules/lambda_1_api"
    prefix = "app"
    lambda_source_file = "lambda.js"
    lambda_output_file = "lambda.zip"
    lambda_handler = "lambda.apiTestHandler"
    api_path = "api"
    stage = "dev"
    ami_id = "version1"
}
