module "lambda_1_api_base" {
    source = "../../modules/lambda_1_api"
    prefix = "app1"
    lambda_source_file = "lambda.js"
    lambda_output_file = "lambda.zip"
    lambda_handler = "lambda.apiTestHandler"
    lambda_env_vars = {
        target = "new world"
    }
    api_path = "api"
    stage = "dev"
    ami_id = "version1"
}

module "lambda_1_api_v2" {
    api_gw_rest = {
        id=module.lambda_1_api_base.api_gw_rest[0].id
        execution_arn = module.lambda_1_api_base.api_gw_rest[0].execution_arn
    }
    api_gw_resource_parent_id = module.lambda_1_api_base.api_gw_rest[0].root_resource_id
    api_gw_method = "ANY"

    source = "../../modules/lambda_1_api"
    prefix = "app2"
    lambda_source_file = "lambda.js"
    lambda_output_file = "lambda.zip"
    lambda_handler = "lambda.apiTestHandler"
    lambda_env_vars = {
        target = "new world 2"
    }

    api_path = "api2"
    stage = "dev"
    ami_id = "version2"
}


module "lambda_1_api_v2_path" {
    api_gw_rest = {
        id=module.lambda_1_api_base.api_gw_rest[0].id
        execution_arn = module.lambda_1_api_base.api_gw_rest[0].execution_arn
    }
    api_gw_resource_parent_id = module.lambda_1_api_v2.api_gw_resource.id
    api_gw_method = "ANY"

    source = "../../modules/lambda_1_api"
    prefix = "app2-path"
    lambda_source_file = "lambda.js"
    lambda_output_file = "lambda.zip"
    lambda_handler = "lambda.apiTestHandler"
    lambda_env_vars = {
        target = "new world 2 - with path"
    }

    api_path = "path"
    stage = "dev"
    ami_id = "version3"
}
