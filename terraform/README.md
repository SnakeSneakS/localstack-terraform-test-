# terraform

# ussage
- `terraform init`
- `terraform plan`
- `terraform apply` or with option `--auto-approve`
- access https://app.localstack.cloud to use web-ui
- enter localstack container
    - `awslocal apigateway get-rest-apis` and check id of endpoint (as $REST_API_ID)
- access  http://localhost:4566/restapis/$REST_API_ID/test/_user_request_/hello_world by browser
    - you will see response `{"message":"hello world! from lambda function."}`
    <!--  http://localhost:4566/restapis/$REST_API_ID/${api_stage}/_user_request_/${rest_api_path} -->
- `terraform apply -destroy`


<!--
# architecture

API GATEWAY > EventBridge > lambda, EC2 (七夕の時だけ彦星からは織姫だけに、普段はその逆) >

steps function でlambdaを繋げる? https://aws.amazon.com/jp/getting-started/hands-on/orchestrate-microservices-with-message-queues-on-step-functions/?pg=ln&sec=uc
-->

<!--
# websites I read
- [terraform-provider-aws CHANGELOG](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md) 
- [terraform official tutorials](https://developer.hashicorp.com/terraform/tutorials)
- [Terraformの基本的なコードの書き方](https://www.collbow.com/blog/iac/3338/)
- [Event Bridge](https://qiita.com/ishibashi-futoshi/items/586ebe17b174a478eb6a)
- [localstack-terraform-samples](https://github.com/localstack/localstack-terraform-samples/tree/master)


-->