cd dist
aws lambda publish-layer-version --layer-name "puppeteer-layer" \
  --description "NodeJS module of puppeteer-core using chrome-aws-lambda" \
  --license-info "MIT" \
  --compatible-runtimes "nodejs14.x" \
  --zip-file "fileb://puppeteer-layer.zip"