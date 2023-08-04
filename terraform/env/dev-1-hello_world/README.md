# Dev 1. Hello World!
This HCL(HashicorpConfigurationLanguage) represents a hello world program by aws lambda through API gateway.

# how to run
- `terraform init`
- `terraform plan`
- `terraform apply` , or with option `--auto-approve`
- access https://app.localstack.cloud to use web-ui
- enter localstack container
    - `awslocal apigateway get-rest-apis` and check id of endpoint as $REST_API_ID (you can check that with web-ui)
- access `http://localhost:4566/restapis/$REST_API_ID/test/_user_request_/api` by browser
    - (API gateway URL is `http://localhost:4566/restapis/$$REST_API_ID/$$STAGE/_user_request_/$PATH`)
    - you will see response `{"message":"hello world! from lambda function."}`
- to destroy deployment, run `terraform destroy`
