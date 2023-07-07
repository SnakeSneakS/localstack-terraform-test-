
# i am
data "aws_iam_policy_document" "lambda_hello_world_assume_role" {
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
resource "aws_iam_role" "lambda_hello_world" {
    name               = "iam_for_lambda_hello_world"
    assume_role_policy = data.aws_iam_policy_document.lambda_hello_world_assume_role.json
}

# lambda
data "archive_file" "lambda_hello_world" {
  type        = "zip"
  source_file = "lambda/hello_world.js"
  output_path = "lambda/hello_world.zip"
}
resource "aws_lambda_function" "lambda_hello_world" {
    filename=data.archive_file.lambda_hello_world.output_path
    function_name = "lambda-hello-world-function"
    role = aws_iam_role.lambda_hello_world.arn
    handler = "hello_world.apiTestHandler"
    source_code_hash = filebase64sha256(data.archive_file.lambda_hello_world.output_path)
    runtime = "nodejs18.x"

    environment {
      variables = {
        foo = "bar"
      }
    }
}

# api gateway
resource "aws_api_gateway_rest_api" "api_gw" {
    name = "hello_world api gateway"
    description = "hello world api gateway"
}
resource "aws_api_gateway_resource" "resource" {
    rest_api_id = aws_api_gateway_rest_api.api_gw.id
    parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
    path_part   = "hello_world"
}
resource "aws_api_gateway_method" "method" {
    rest_api_id = aws_api_gateway_rest_api.api_gw.id
    resource_id   = aws_api_gateway_resource.resource.id
    http_method = "ANY"
    authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.method]
}

# api gateway and lambda
resource "aws_api_gateway_integration" "lambda" {
    rest_api_id = aws_api_gateway_rest_api.api_gw.id
    resource_id = aws_api_gateway_method.method.resource_id
    http_method = aws_api_gateway_method.method.http_method
    integration_http_method = "ANY"
    type = "AWS_PROXY"
    uri = aws_lambda_function.lambda_hello_world.invoke_arn
    timeout_milliseconds = 2000

    request_templates = {
      "application/json" = <<-EOF
        {"statusCode": 200}
      EOF
    }

    #request_parameters = {
    #    "integration.request.header.X-Authorization" = "'static'"
    #}
}
#resource "aws_api_gateway_integration_response" "options_integration_response" {
#  rest_api_id = aws_api_gateway_rest_api.api_gw.id
#  resource_id = aws_api_gateway_resource.resource.id
#  http_method = aws_api_gateway_method.method.http_method
#  status_code = aws_api_gateway_method_response.options_200.status_code
#  response_parameters = {
#    "method.response.header.Access-Control-Allow-Headers" = "context.requestOverride.header.Access-Control-Request-Headers",
#    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
#    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#  }
#  depends_on = [aws_api_gateway_method_response.options_200]
#}
resource "aws_api_gateway_deployment" "apigw_deployment" {
    depends_on = [
        aws_api_gateway_integration.lambda,
    ]
    rest_api_id = aws_api_gateway_rest_api.api_gw.id
    stage_name = var.stage
}
resource "aws_lambda_permission" "apigw" {
    statement_id = "AllowExecutionFromAPIGateway" #"AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_hello_world.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*/*"
}

# schedule trigger cloudwatch
#resource "aws_cloudwatch_log_group" "hello_world" {
#  name              = "/aws/lambda/${aws_api_gateway_rest_api.api_gw.id}"
#  retention_in_days = 14
#}
#resource "aws_cloudwatch_event_rule" "hello_world" {
#  name                = "hello_world"
#  description         = "Rule to run hello_world every second."
#  schedule_expression = "cron(* * * * ? *)"
#  is_enabled          = true
#}
#resource "aws_cloudwatch_event_target" "hello_world" {
#  rule      = aws_cloudwatch_event_rule.hello_world.name
#  target_id = aws_cloudwatch_event_rule.hello_world.name
#  arn       = aws_lambda_function.lambda_hello_world.arn
#}
#resource "aws_lambda_permission" "sample_app" {
#  statement_id  = "AllowExecutionFromCloudWatch"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.lambda_hello_world.function_name
#  principal     = "events.amazonaws.com"
#  source_arn    = aws_cloudwatch_event_rule.hello_world.arn
#}