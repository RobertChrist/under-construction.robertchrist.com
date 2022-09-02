resource "aws_api_gateway_model" "error__post" {
  content_type = "application/json"
  description  = "The error information to log"
  name         = "ErrorInfo"
  rest_api_id  = aws_api_gateway_rest_api.error.id
  schema       = <<EOT
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "ErrorInfo",
  "type": "object",
  "properties": {
    "name": {
      "type": "string"
    },
    "message": {
      "type": "string"
    },
    "stack": {
      "type": "string"
    },
    "callingApp": {
      "type": "string"
    },
    "additionalDetails": {
      "type": "string"
    }
  }
}
EOT
}