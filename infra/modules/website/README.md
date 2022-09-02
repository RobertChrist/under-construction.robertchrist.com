## Overview
This module is responsible for all infrastructure related to hosting the website.

## Architecture
* **S3** 
An AWS s3 bucket is used to host the static files that comprise the website.  

* **CloudFront** 
The website will be accessible to the public via our CDN, which will sit in front of our S3 bucket.

* **Route53** 
For DNS management, connecting our domain name to our CDN.
 
* **ACM**
For managing our https certificate for our domain name.

## Terraform Limitations - Manual Steps Required Outside of Terraform
* **Purchase a Domain Name**
These configuration files assume that the repository owner has already purchased `${var.project_hostname}` from a domain name registrar.

## Architecture Notes

 The s3 bucket is configured as a website endpoint, instead of a REST API endpoint, as [that has some advantages for a simple static website such as this.](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteEndpoints.html#WebsiteRestEndpointDiff)
 
 Unfortunately, this comes with two major drawbacks:
 
 1. S3 buckets that are configured as website endpoints cannot be fully restricted to only allow access from CloudFront distributions
     * To address this, the s3 bucket is configured to ignore all http traffic that does not include a secret key in the headers.  This header key is then set for all requests that originate from the CloudFront distribution. This, ideally, limits the amount of traffic that will serve directly from the s3 bucket.  This is a recommended AWS practice, [as documented here](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)
 1. S3 buckets that are configured as website enpoints do not support https.
    * This issue is not addressed.  As such traffic between CloudFront and S3 will not be sent over https.  We assume that due to the nature of content handled by this application, this is a reasonable tradeoff.
 