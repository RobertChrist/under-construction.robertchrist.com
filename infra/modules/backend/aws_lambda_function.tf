resource "aws_lambda_function" "snslistener_contactform_emailer" {
  architectures                  = ["x86_64"]
  function_name                  = "snslistener-contactform-emailer"
  handler                        = "index.handler"
  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = aws_iam_role.lambda__log_to_cloudwatch_role.arn
  runtime                        = "nodejs14.x"

  // Optional, used to track currently deployed source code version.
  source_code_hash               = "4JIC0C1G5w1b65ARPenV9yf7qH73DZP6LXYsSgskM3Y="
  timeout                        = "3"

  tracing_config {
    mode = "PassThrough"
  }
}