resource "aws_api_gateway_deployment" "contact_form__deployment" {
  rest_api_id   = aws_api_gateway_rest_api.contact_form.id
    
    // https://github.com/hashicorp/terraform-provider-aws/issues/162
    // For new changes to the API to be correctly deployed, they need to
    // be detected by terraform as a trigger to recreate the aws_api_gateway_deployment.
    // This is because AWS keeps a "working copy" of the API resources which does not
    // go live until a new aws_api_gateway_deployment is created.
    // Here we use a dummy stage variable to force a new aws_api_gateway_deployment.
    // We want it to detect if any of the API-defining resources have changed so we
    // hash all of their configurations.
    // IMPORTANT: This list must include all API resources that define the "content" of
    // the rest API. That means anything except for aws_api_gateway_rest_api,
    // aws_api_gateway_stage, aws_api_gateway_base_path_mapping, that are higher-level
    // resources. Any change to a part of the API not included in this list might not
    // trigger creation of a new aws_api_gateway_deployment and thus not fully deployed.
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_api_key.project_key,

      // including these two files introduces circular dependencies in our module, so let's just read the configuration for changes.
      // these two files we can be safe that we only care about changes, if the configuration itself changes.
      md5(file("${path.module}/aws_api_gateway_usage_plan.tf")),
      md5(file("${path.module}/aws_api_gateway_usage_plan_key.tf")),
      
      aws_api_gateway_rest_api.contact_form,
      aws_api_gateway_resource.contact_form, 
      
      aws_api_gateway_method.contact_form__preflight_options,
      aws_api_gateway_integration.contact_form__preflight_options,
      aws_api_gateway_integration_response.contact_form__preflight_options,
      aws_api_gateway_method_response.contact_form__preflight_options,

      aws_api_gateway_model.contact_form__post,
      aws_api_gateway_request_validator.contact_form__post,

      aws_api_gateway_method.contact_form__post,
      aws_api_gateway_integration.contact_form__post,
      aws_api_gateway_integration_response.contact_form__post_200,
      aws_api_gateway_integration_response.contact_form__post_400,
      aws_api_gateway_integration_response.contact_form__post_500,
      aws_api_gateway_method_response.contact_form__post_200,
      aws_api_gateway_method_response.contact_form__post_400,
      aws_api_gateway_method_response.contact_form__post_500
    ]))
  }

  lifecycle {
    create_before_destroy  = true
  }
}