## Overview

This module is responsible for defining all CloudWatch and CloudFront logs, ensuring they are ingested into SumoLogic, then configuring our SumoLogic dashboard to allow for monitoring of the Production environment.

## Architecture
**CloudFront**
* **IAM**
Cloudfront is configured in the [../backend](../backend) module to log to an s3 bucket.  These IAM policies and roles ensure that the SumoLogic S3 bucket collector has the required permissions needed to ingest these files.

* **sumologic_collector_source**
  These files are then collected via the sumologic S3 collector resource `sumolgoic_cloudfront_source.aws_cloudfront`.

**CloudWatch**
The CloudWatch configuration defined here follows the best practices defined in SumoLogic's CloudWatch Ingestion documentation, [available here](https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Amazon-CloudWatch-Logs#validate-email-address-for-alarms).

* **CloudWatch Log Groups**
All non-CloudFront AWS components defined in the [/infra](../../) folder are configured to log to CloudWatch.  This file defines and connects Terraform to these CloudWatch log groups.

* **sumologic_collector_source**
The sumologic resource `sumologic_http_source.aws_cloudwatch_endpoint` defines an http endpoint which will receive logging statements for ingestion, provided the data comes from AWS Cloudwatch.

* **CloudFormation**
SumoLogic provides a CloudFormation template [available here](https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Amazon-CloudWatch-Logs) to configure their ingestor service.  This CloudFormation stack is repsonsible for reading in new events from CloudWatch, and then using a queue and a lambda to send that data to the http endpoint defined in `sumologic_http_source.aws_cloudwatch_endpoint` above.

* **cloudwatch_log_subscription_filters**
CloudWatch Log Groups we wish to ingest into SumoLogic must be configured to stream their data into the SumoLogic CloudFormation resources.  This is done via the subscription filters in this file.

* **sumologic_dashboard**
Defines a SumoLogic Dashboard that parses the collected logs, pre-configured to monitor the repository's application.

* **sumologic_dashboard_queries**
For ease of understanding, all of the queries used in the SumoLogic Dashboard have been broken out into their own file, called [sumologic_dashboard_queries.tf](sumologic_dashboard_queries.tf).

## Terraform Limitations - Manual Steps Required Outside of Terraform
* **CloudWatch Log Ingestor Alarms - Manually Validate Email Address**
AWS requires that you manually validate your email address in order to receive notifications if the SumoLogic CloudFormation-managed resources experience an error while ingesting CloudWatch logs.  Documentation of this issue is available here: https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Amazon-CloudWatch-Logs#validate-email-address-for-alarms