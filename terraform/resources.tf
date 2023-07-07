# kinesis
resource "aws_kinesis_stream" "local_stream" {
  name             = "local-stream"
  shard_count      = 1
  retention_period = 168
}
# lambda
#resource "aws_lambda_event_source_mapping" "local_mapping" {
#  event_source_arn                   = aws_kinesis_stream.local_stream.arn
#  function_name                      = aws_lambda_function.local_lambda.arn
#  starting_position                  = "LATEST"
#  maximum_retry_attempts             = 1
#  batch_size                         = 100
#  maximum_batching_window_in_seconds = 5
#}
#
#resource "aws_lambda_function" "local_lambda" {
#  filename      = "lambda.zip"
#  function_name = "local-lambda"
#  role          = aws_iam_role.local_role.arn
#  handler       = "lambda"
#  runtime       = "go1.x"
#}

# iam
#resource "aws_iam_role" "local_role" {
#  name               = "local-role"
#  assume_role_policy = <<EOF
#{
#	"Version": "2012-10-17",
#	"Statement": [
#		{
#			"Action": "sts:AssumeRole",
#			"Principal": {
#				"Service": "lambda.amazonaws.com"
#			},
#			"Effect": "Allow",
#			"Sid": ""
#		},
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#          "Service": "scheduler.amazonaws.com"
#      },
#      "Effect": "Allow"
#    }
#	]
#}
#EOF
#}
#
#
#
#{
#  "Sid": "PolicyForStartEC2Instance",
#  "Effect": "Allow",
#  "Action": "ec2:StartInstances",
#  "Resource": "*"
#},
#{
#    "Sid": "PolicyForStopEC2Instance",
#    "Effect": "Allow",
#    "Action": "ec2:StopInstances",
#    "Resource": "*"
#}





#resource "aws_iam_policy" "local_policy" {
#  name   = "local-iam-policy"
#  policy = data.aws_iam_policy_document.local_policy_document.json
#}
#
#data "aws_iam_policy_document" "local_policy_document" {
#  statement {
#    effect = "Allow"
#    actions = [
#      "s3:GetObject",
#      "s3:ListBucket",
#      "s3:PutBucketNotification",
#      "s3:PutObject",
#      "s3:DeleteObject",
#    ]
#    resources = ["*"]
#  }
#  statement {
#    effect = "Allow"
#    actions = [
#      "kinesis:DescribeStream",
#      "kinesis:GetShardIterator",
#      "kinesis:GetRecords"
#    ]
#    resources = ["*"]
#  }
#}
#resource "aws_iam_role_policy_attachment" "local_poilcy_attachment" {
#  role       = aws_iam_role.local_role.name
#  policy_arn = aws_iam_policy.local_policy.arn
#}


# S3
resource "aws_s3_bucket" "s3-local-archive" {
  count = 2
  bucket = "s3-local-archive-${count.index}"
  tags = {
    Name        = "bucket ${count.index}"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_acl" "s3-local-archive" {
  bucket = aws_s3_bucket.s3-local-archive[0].id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "s3-local-archive-versioning" {
  bucket = aws_s3_bucket.s3-local-archive[0].id
  versioning_configuration {
    status = "Enabled" # Disabled
  }
  depends_on = [aws_s3_bucket.s3-local-archive[0]]
  #provider="aws"
  #lifecycle=""
}

