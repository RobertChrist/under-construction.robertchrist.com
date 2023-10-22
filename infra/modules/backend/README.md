## Overview

This module is responsible for handling all of the backend infrastructure of the repository, that is not handled by any other module.

## Architecture
* **IAM policy**
AWS Identity Access Management Profiles.

* **ACM Certificate**
The API Gateway runs at a custom domain of `https://api.${var.project_name}`, and therefore needs an https certificate.

* **Route 53**
The API Gateway runs at the custom domain of `https://api.${var.project_name}`, which is managed in route53.
This module takes in as a variable the hosted zone id, as it assumes the related website module is responsible for managing the hosted zone for `https://${var.project_name}`.

* **API Gateway**
This repository is a serverless application.  Requests from the website are sent to AWS API Gateway for handling.
  * Model Validation and CORS headers are handled in API Gateway, see architecture notes below for more information.
  * Because the custom domain is edge-optimized, the Api Gateway is not.  See Architecture Notes below for more information.

  * **aws_api_gateway_deployment** resources are used in this module to ensure that the API Gateway is automatically redeployed during the terraform apply stage when a dependent resource has been changed.  See the endpoint specific corresponding aws_api_gateway_deployment.tf file for more information.

* **SNS**
Requests that successfully make their way through API gateway are then passed on to SNS.  This allows us to handle the incoming requests asyncronously, and makes the website far more responsive.

* **SNS Subscribers**
SNS subscribers are used to notify the repository owner via email whenever an error or new contact request is made via the website.  SNS then additionally triggers a lambda function.

* **Lambda**
[/src/lambdas/lambda/SNSListener-ContactForm-Emailer](/src/lambdas/lambda/SNSListener-ContactForm-Emailer) is triggered from SNS if the incoming request was a contact request.  Depending on the version of this repository you are looking at, this lambda is likely either configured to email the repository owner, or respond to the website user, automatically, from a custom domain gmail account.

## Architecture Notes
* **Lambda vs Api Gateway for Model Validation and CORS Origin Header Management**
  API Gateway provides two different techniques for managing CORS headers, and validating request models.

  The easiest option is to pass our raw request from api gateway to a lambda function, and allow the lambda to handle both of these requirements.  However, this means that lambdas will have to execute for each request (potentially twice, once for the request, once to validate CORS headers for the OPTIONS call).  Each of tehse lambda executions will have a latency and a (small) monetary price attached.  If the lambda has a cold start, this latency period can be significant.

   Alternatively, Api Gateway is capable of model validation in a method request, and the vtl templating language can be used to dynamically set the CORS origin header against a pre-hardcoded list.  This has the disadvantage that your model validation logic rests in a different aws service (API Gateway) than the business logic that uses the model (AWS Lambda functions).  Similarly, the vtl templating language must be used to set the origin header from a hardcoded list of domains.  However, if this path is chosen, latency becomes absolutely minimal, as there is no delay in waiting for a lambda to execute or cold-start (or alternatively, keep a lambda warm), and the Api Gateway can respond entirely from its edge-optimized location.  Similarly, OPTIONS calls can be handled entirely without a lambda (a MOCK call type can handle) for no cost, as can be requests with improper model validation.  This all results in extremely quick, and no-monetary-cost responses for such calls.

    Since this project expects invalid bot traffic to be more frequent than valid contact request traffic, and the frequency of contact requests to be infrequent enough to make lambda cold starts a significant issue, the second option was chosen.  As a result these terraform files include the settings and scripts for model validation and CORS origin header templating, and this logic does not exist in the /src folder.

* **Edge Optimized** 
Api Gateways are edge optimized for increased performance.  However, because we are using an edge optimized custom domain (`api.${var.project_name}`), we don't set the api itself as edge optimized. A StackOverflow [post here goes into more detail](https://stackoverflow.com/questions/49826230/regional-edge-optimized-api-gateway-vs-regional-edge-optimized-custom-domain-nam), and the AWS documentation itself suggests using a regional endpoint in this scenario as well, [as seen here](https://aws.amazon.com/premiumsupport/knowledge-center/api-gateway-cloudfront-distribution/).

## Terraform Limitations - Manual Steps Required Outside of Terraform

* **API Gateway Certificate for Api Domain - Manual Email Validation Required**
  The Api Gateway runs on a custom domain name, of `https://api.${var.project_name}`.  This is a custom domain managed in route53, and has its own https certificate managed in ACM.  

  As such, this certificate needs to be manually validated.  The configuration here assumes you will validate by email.  To do this, go to the AWS ACM certificate manager, click the api.project_name certificate, and go through the email validation process.

* **SNS Email Subscriptions - Manual Email Validation Required**
  Must be manually confirmed each time they are created, and the email address validated via the AWS UI.  As of 3/11/2022, Terraform only has partial support for this endpoint type.  To do so, click on the SNS email subscriptions for each of the SNS topics created by terraform in the UI, and follow the email validation process.

* **SNS SMS Subscriptions**

  * **Pinpoint Origination Number - Manual Registration Required**
  Starting in June, 2021, AWS requires that you manually create at least one "origination number" associated with your account before SNS can begin sending sms messages.
  
    The cheapest way to do this is to simply register a "long form", toll-free , phone number.  The type specified should be "TRANSACTIONAL".

    This must be done manually, as it is not currently supported in Terraform.  Follow the steps for registering a new number to your AWS account in the AWS Pinpoint service.

  * **Complete SMS Setting Configuration - Manual Settings Required**
  Once you have manually registered your origination number, you can begin setting up your SNS SMS preferences.  The terraform file [aws_sns_sms_preferences.tf](aws_sns_sms_preferences.tf) will help guide you on this, but you must still take some actions manually.

    The primary two concerns will be getting your account verified in the AWS SNS and Pinpoint UIs to ensure that texts are sent consistently, and determining whether you need to manually contact AWS to increase the default number of sms messages allowed from your account (the default is 50 / week).  Both of these issues, if unresolved, can cause SMS texts to fail to send.  As a result, there is a dedicated section on the SumoLogic monitoring dashboard watching for any such failures.

  * **Api Gateway Resources must be registered in the aws_api_gatewaye__*__deployment resource in order to ensure deployment**
    
    https://github.com/hashicorp/terraform-provider-aws/issues/162
    AWS Api Gateway keeps a "working copy" of all api resources, which does not change until API Gateway is redeployed.
    This means that if we use terraform to update an api gateway resource, but do not trigger a new aws_api_gateway_deployment, the Api Gateway will continue running on an old, outdated "working copy" of the resource until we do so, even though we have already updated the resource itself.
    To work around this issue, we have created aws_api_gateway__*__deployment files which reference all of our aws_api_gateway resources.  If one of those resources change, terraform will detect a change in the dummy variable in aws_api_gateway____deployment, and will automatially redeploy API Gateway.
    The downside of this approach, is it means that all API Gateway resources must be manually referenced in the aws_api_gateway__*__deployment file.
    
## Potential Future Improvements
* **Code Deduplication - Common Module for Api Gateway Apis**
  These Terraform configuration files define two api endpoints, contact-form and error.  These two endpoints are configured nearly identically.

  As such, we could potentially deduplicate this code substantially by either writing a custom module to configure these endpoints from a single template, or look into public modules available for this purpose.
  
  I do not think the effort to deduplicate this code in such a manner is worthwhile while this project has only two endpoints, but it likely would be worth doing if this project were to grow substantially in the future and endpoints continued to remain this similar.

* **Https endpoints for lambdas**
  On April 6th, AWS announced https endpoints for lambdas.  Currently, these lambdas do not work with custom domains or have any form of rate limiting, but they do allow for built-in management of CORS headers.  As this feature improves, we may be able to replace API Gateway.