data "aws_lambda_layer_version" "puppeteer_layer_latest" {
  compatible_runtime = "nodejs14.x"
  layer_name          = "puppeteer-layer"
}