
resource "random_pet" "a" {
  length = 2
  separator="-"
  prefix = null
  keepers = {
    ami_id = var.ami_id # Generate a new pet name each time we switch to a new AMI id
  }
}

# i am
data "aws_iam_policy_document" "lambda_iam_policy" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        principals {
            type        = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
        sid = ""
        actions = ["sts:AssumeRole"]
    }
}
resource "aws_iam_role" "lambda_iam_role" {
    name               = "${var.prefix}_iam_for_lambda_${random_pet.a.id}"
    assume_role_policy = data.aws_iam_policy_document.lambda_iam_policy.json
}

# lambda
data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = var.lambda_output_file
}
resource "aws_lambda_function" "lambda_function" {
    filename=data.archive_file.lambda_archive.output_path
    function_name = "${var.prefix}_lambda_function_${random_pet.a.id}"
    role = aws_iam_role.lambda_iam_role.arn
    handler = var.lambda_handler
    source_code_hash = filebase64sha256(data.archive_file.lambda_archive.output_path)
    runtime = "nodejs18.x"

    environment {
      variables = {
        foo = "bar"
      }
    }
}

# api gateway
resource "aws_api_gateway_rest_api" "api_gw_rest" {
    name = "${var.prefix}_api_gateway_${random_pet.a.id}"
    description = "${var.prefix} api gateway"
}
resource "aws_api_gateway_resource" "api_gw_resource" {
    rest_api_id = aws_api_gateway_rest_api.api_gw_rest.id
    parent_id   = aws_api_gateway_rest_api.api_gw_rest.root_resource_id
    path_part   = var.api_path
}
resource "aws_api_gateway_method" "api_gw_method" {
    rest_api_id = aws_api_gateway_rest_api.api_gw_rest.id
    resource_id   = aws_api_gateway_resource.api_gw_resource.id
    http_method = "ANY"
    authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gw_rest.id
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  http_method = aws_api_gateway_method.api_gw_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.api_gw_method]
}

# api gateway and lambda
resource "aws_api_gateway_integration" "lambda" {
    rest_api_id = aws_api_gateway_rest_api.api_gw_rest.id
    resource_id = aws_api_gateway_method.api_gw_method.resource_id
    http_method = aws_api_gateway_method.api_gw_method.http_method
    integration_http_method = "ANY"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda_function.invoke_arn
    timeout_milliseconds = 2000

    request_templates = {
      "application/json" = <<-EOF
        {"statusCode": 200}
      EOF
    }
}
resource "aws_api_gateway_deployment" "api_gw_deployment" {
    depends_on = [
        aws_api_gateway_integration.lambda,
    ]
    rest_api_id = aws_api_gateway_rest_api.api_gw_rest.id
    stage_name = var.stage
}
resource "aws_lambda_permission" "api_gw" {
    statement_id = "AllowExecutionFromAPIGateway" #"AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_function.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.api_gw_rest.execution_arn}/*/*"
}
