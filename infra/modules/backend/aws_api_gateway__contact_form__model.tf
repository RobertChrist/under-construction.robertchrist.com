locals {
  project_name_alphanumerics = replace(var.project_name, "/[^a-zA-Z\\d]/", "")
}

resource "aws_api_gateway_model" "contact_form__post" {
  rest_api_id      = aws_api_gateway_rest_api.contact_form.id

  content_type = "application/json"
  name         = "${local.project_name_alphanumerics}ContactFormModel"
  schema       = <<-EOT
    {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "title": "${local.project_name_alphanumerics}ContactFormModel",
      "type": "object",
      "properties": {
        "name": {
          "type": "string"
        },
        "email": {
          "type": "string",
          "pattern": ".{1,}[@].{1,}"
        },
        "message": {
          "type": "string"
        },
        "callingApp": {
          "type": "string"
        },
        "token": {
          "type": "string"
        }
      },
      "additionalProperties": false,
      "required": [
        "name", "email", "callingApp", "token"
      ]   
    }
EOT
}