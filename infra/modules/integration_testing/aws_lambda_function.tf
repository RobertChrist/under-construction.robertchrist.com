# We increase the memory size and timeout time from the default for this function, 
# because it uses puppeteer in its associated lambda layer.  Pupeeteer requires
# these extra resources due to the weight of the package.
resource "aws_lambda_function" "cwevent_contactform_integrationtester" {
  architectures                  = ["x86_64"]
  function_name                  = "cwevent-contactform-integrationtester"
  handler                        = "index.handler"
  layers                         = [data.aws_lambda_layer_version.puppeteer_layer_latest.arn]
  
  memory_size                    = "1600"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = var.aws_iam_role__lambda__log_to_cloudwatch_arn
  runtime                        = "nodejs14.x"

  // Optional, used to track currently deployed source code version.
  source_code_hash               = "Y1Hl0lgsRR1ovQHN7iPcy/ZacwfZ10YkXOEYtOAmKes="
  timeout                        = "120"

  tracing_config {
    mode = "PassThrough"
  }
}