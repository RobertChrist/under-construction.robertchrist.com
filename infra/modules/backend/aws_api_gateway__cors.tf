locals {
  cors_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${var.project_hostname}'"
  }

  # We wish to accept CORS traffice from https://${var.project_hostname} AND https://www.${var.project_hostname}.
  # This means we need to compare the incoming request's value with a pre-selected list, and if the value exists on
  # our list, dynamically set that on our outgoing response.  In API Gateway, this is done with the velocity templates as seen below.
  cors_response_template = {
    "application/json" = <<-EOT
      #set($altDomains = ["https://www.${var.project_hostname}"])
      #set($origin = $input.params("origin"))
      #if($altDomains.contains($origin))
      #set($context.responseOverride.header.Access-Control-Allow-Origin="$origin")
      #end
      EOT
  }

  cors_response_parameters_all_false = {
    "method.response.header.Access-Control-Allow-Headers" = "false"
    "method.response.header.Access-Control-Allow-Methods" = "false"
    "method.response.header.Access-Control-Allow-Origin"  = "false"
  }
}