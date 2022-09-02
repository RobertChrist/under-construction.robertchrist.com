  # SumoLogic provides a CloudFormation template [available here](https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Amazon-CloudWatch-Logs)
  # to configure their ingestor service.  This CloudFormation stack is repsonsible for reading in new events from CloudWatch, 
  # and then using a queue and a lambda to send that data to the http endpoint defined in sumologic_http_source.aws_cloudwatch_endpoint.

  # Manaing this resource stack via CloudFormation instead of managing each resource directly via Terraform means if SumoLogic
  # makes any signiicant changes to their documentation, we will be able to quickly swap out this stack with their newly suggested
  # version.  However, it does mean that detecting drift to these resources will need to be managed in Cloudformation, instead of Terraform.
  # We have added a special Tag "Terraform via CloudFormation" to make this more obvious when investigating these AWS resources through other UIs.
resource "aws_cloudformation_stack" "sumologic_ingestor_stack" {
  capabilities     = ["CAPABILITY_IAM"]
  disable_rollback = "false"
  name             = "SumoLogic-Ingestor-Stack"
  tags             = {
      "Terraform via Cloudformation" = var.project_name
  }
  template_body    = <<-EOT
  {
      "AWSTemplateFormatVersion": "2010-09-09",
      "Description" : "Sumo Logic CloudWatch log collector",
      "Parameters" : {
        "SumoEndPointURL" : {
          "Type" : "String",
          "Default" : "${sumologic_http_source.aws_cloudwatch_endpoint.url}",
          "Description" : "Enter SUMO_ENDPOINT created while configuring HTTP Source"
        },
        "EmailID": {
          "Type": "String",
          "Default": "${var.email_address_to_alert_on_sumologic_ingest_failure}",
          "Description": "Enter your email for receiving alerts.You will receive confirmation email after the deployment is complete, confirm it to subscribe for alerts."
        },
        "NumOfWorkers": {
          "Type": "Number",
          "Default": 4,
          "Description": "Enter the number of lambda function invocations for faster Dead Letter Queue processing."
        },
        "LogFormat": {
          "Type": "String",
          "Default": "Others",
          "AllowedValues" : ["VPC-RAW" ,"VPC-JSON", "Others"],
          "Description": "Choose the Service"
        },
        "IncludeLogGroupInfo": {
          "Type": "String",
          "Default": "false",
          "AllowedValues" : ["true" ,"false"],
          "Description": "Select true to get loggroup/logstream values in logs"
        },
        "LogStreamPrefix": {
          "Type": "String",
          "Description": "(Optional) Enter comma separated list of logStream name prefixes to filter by logStream. Please note this is seperate from a logGroup. This is used to only send certain logStreams within a cloudwatch logGroup(s). LogGroups still need to be subscribed to the created Lambda funciton, regardless of what is input for this value.",
          "Default": ""
        }
      },
      "Mappings" : {
          "RegionMap" : {
              "us-east-1": {"bucketname": "appdevzipfiles-us-east-1"},
              "us-east-2": {"bucketname": "appdevzipfiles-us-east-2"},
              "us-west-1": {"bucketname": "appdevzipfiles-us-west-1"},
              "us-west-2": {"bucketname": "appdevzipfiles-us-west-2"},
              "ap-south-1": {"bucketname": "appdevzipfiles-ap-south-1"},
              "ap-northeast-2": {"bucketname": "appdevzipfiles-ap-northeast-2"},
              "ap-southeast-1": {"bucketname": "appdevzipfiles-ap-southeast-1"},
              "ap-southeast-2": {"bucketname": "appdevzipfiles-ap-southeast-2"},
              "ap-northeast-1": {"bucketname": "appdevzipfiles-ap-northeast-1"},
              "ap-east-1": {"bucketname": "appdevzipfiles-ap-east-1s"},
              "af-south-1": {"bucketname": "appdevzipfiles-af-south-1s"},
              "ca-central-1": {"bucketname": "appdevzipfiles-ca-central-1"},
              "eu-central-1": {"bucketname": "appdevzipfiles-eu-central-1"},
              "eu-west-1": {"bucketname": "appdevzipfiles-eu-west-1"},
              "eu-west-2": {"bucketname": "appdevzipfiles-eu-west-2"},
              "eu-west-3": {"bucketname": "appdevzipfiles-eu-west-3"},
              "eu-north-1": {"bucketname": "appdevzipfiles-eu-north-1s"},
              "eu-south-1": {"bucketname": "appdevzipfiles-eu-south-1"},
              "me-south-1": {"bucketname": "appdevzipfiles-me-south-1s"},
              "sa-east-1": {"bucketname": "appdevzipfiles-sa-east-1"}
          }
      },
      "Resources": {
          "SumoCWLogGroup": {
              "Type": "AWS::Logs::LogGroup",
              "Properties": {
                  "LogGroupName": { "Fn::Join": [ "-", [ "SumoCWLogGroup", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] },
                  "RetentionInDays": 7
              }
          },
          "SumoCWLogSubsriptionFilter": {
              "Type": "AWS::Logs::SubscriptionFilter",
              "Properties": {
                  "LogGroupName": {
                      "Ref": "SumoCWLogGroup"
                  },
                  "DestinationArn": {
                      "Fn::GetAtt": [
                          "SumoCWLogsLambda",
                          "Arn"
                      ]
                  },
                  "FilterPattern": ""
              },
              "DependsOn": [
                  "SumoCWLogGroup",
                  "SumoCWLambdaPermission",
                  "SumoCWLogsLambda"
              ]
          },
          "SumoCWLambdaPermission": {

              "Type": "AWS::Lambda::Permission",

              "Properties": {

                  "FunctionName": {
                      "Fn::GetAtt": [
                          "SumoCWLogsLambda",
                          "Arn"
                      ]
                  },
                  "Action": "lambda:InvokeFunction",

                  "Principal": { "Fn::Join": [ ".", [ "logs", { "Ref": "AWS::Region" }, "amazonaws.com" ] ] },

                  "SourceAccount": { "Ref": "AWS::AccountId" }
              }
          },
          "SumoCWDeadLetterQueue": {
              "Type": "AWS::SQS::Queue",
              "Properties": {
                  "QueueName": { "Fn::Join": [ "-", [ "SumoCWDeadLetterQueue", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] }
              }
          },
          "SumoCWLambdaExecutionRole": {
              "Type": "AWS::IAM::Role",
              "Properties": {
                  "AssumeRolePolicyDocument": {
                      "Version": "2012-10-17",
                      "Statement": [{
                          "Effect": "Allow",
                          "Principal": {"Service": ["lambda.amazonaws.com"] },
                          "Action": ["sts:AssumeRole"]
                      } ]
                  },
                  "Path": "/",
                  "Policies": [
                      {
                          "PolicyName": { "Fn::Join": [ "-", [ "SQSCreateLogsRolePolicy", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] },
                          "PolicyDocument": {
                              "Version": "2012-10-17",
                              "Statement": [{
                                  "Effect": "Allow",
                                  "Action": [
                                      "sqs:DeleteMessage",
                                      "sqs:GetQueueUrl",
                                      "sqs:ListQueues",
                                      "sqs:ChangeMessageVisibility",
                                      "sqs:SendMessageBatch",
                                      "sqs:ReceiveMessage",
                                      "sqs:SendMessage",
                                      "sqs:GetQueueAttributes",
                                      "sqs:ListQueueTags",
                                      "sqs:ListDeadLetterSourceQueues",
                                      "sqs:DeleteMessageBatch",
                                      "sqs:PurgeQueue",
                                      "sqs:DeleteQueue",
                                      "sqs:CreateQueue",
                                      "sqs:ChangeMessageVisibilityBatch",
                                      "sqs:SetQueueAttributes"
                                  ],
                                  "Resource": [
                                      {
                                          "Fn::GetAtt": [
                                              "SumoCWDeadLetterQueue",
                                              "Arn"
                                          ]
                                      }
                                  ]
                              }]
                          }
                      },
                      {
                          "PolicyName": { "Fn::Join": [ "-", [ "CloudWatchCreateLogsRolePolicy", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] },
                          "PolicyDocument": {
                              "Version": "2012-10-17",
                              "Statement": [{
                                  "Effect": "Allow",
                                  "Action": [
                                      "logs:CreateLogGroup",
                                      "logs:CreateLogStream",
                                      "logs:PutLogEvents",
                                      "logs:DescribeLogStreams"
                                  ],
                                  "Resource": [
                                      { "Fn::Join": [ ":", ["arn", "aws", "logs", { "Ref" : "AWS::Region" }, { "Ref" : "AWS::AccountId" },"log-group","*" ] ] }
                                  ]
                              }]
                          }
                      },
                      {
                          "PolicyName": "InvokeLambdaRolePolicy",
                          "PolicyDocument": {
                              "Version": "2012-10-17",
                              "Statement": [{
                                  "Effect": "Allow",
                                  "Action": [
                                      "lambda:InvokeFunction"
                                  ],
                                  "Resource": [
                                        { "Fn::Join": [ ":", ["arn", "aws", "lambda", { "Ref" : "AWS::Region" }, { "Ref" : "AWS::AccountId" }, "function", { "Fn::Join": [ "-", [ "SumoCWProcessDLQLambda", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] } ] ] }
                                  ]
                              }]
                          }
                      }
                  ]
              }
          },
          "SumoCWLogsLambda": {
              "Type": "AWS::Lambda::Function",
              "DependsOn": [
                  "SumoCWLambdaExecutionRole",
                  "SumoCWDeadLetterQueue"
              ],
              "Properties": {
                  "FunctionName": { "Fn::Join": [ "-", [ "SumoCWLogsLambda", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] },
                  "Code": {
                      "S3Bucket": { "Fn::FindInMap" : [ "RegionMap", { "Ref" : "AWS::Region" }, "bucketname"]},
                      "S3Key": "cloudwatchlogs-with-dlq.zip"
                  },
                  "Role": {
                      "Fn::GetAtt": [
                          "SumoCWLambdaExecutionRole",
                          "Arn"
                      ]
                  },
                  "Timeout": 300,
                  "DeadLetterConfig": {
                      "TargetArn" : {
                          "Fn::GetAtt": [
                              "SumoCWDeadLetterQueue",
                              "Arn"
                          ]
                      }
                  },
                  "Handler": "cloudwatchlogs_lambda.handler",
                  "Runtime": "nodejs14.x",
                  "MemorySize": 128,
                  "Environment": {
                      "Variables": {
                          "SUMO_ENDPOINT": {"Ref": "SumoEndPointURL"},
                          "LOG_FORMAT": {"Ref": "LogFormat"},
                          "INCLUDE_LOG_INFO": {"Ref": "IncludeLogGroupInfo"},
                          "LOG_STREAM_PREFIX": {"Ref": "LogStreamPrefix"}

                      }
                  }
              }
          },
          "SumoCWEventsInvokeLambdaPermission": {
              "Type": "AWS::Lambda::Permission",
              "Properties": {
                  "FunctionName": { "Ref": "SumoCWProcessDLQLambda" },
                  "Action": "lambda:InvokeFunction",
                  "Principal": "events.amazonaws.com",
                  "SourceArn": { "Fn::GetAtt": ["SumoCWProcessDLQScheduleRule", "Arn"] }
              }
          },
          "SumoCWProcessDLQScheduleRule": {
              "Type": "AWS::Events::Rule",
              "Properties": {
                  "Description": "Events rule for Cron",
                  "ScheduleExpression": "rate(5 minutes)",
                  "State": "ENABLED",
                  "Targets": [{
                      "Arn": { "Fn::GetAtt": ["SumoCWProcessDLQLambda", "Arn"] },
                      "Id": "TargetFunctionV1"
                  }]
              }
          },
          "SumoCWProcessDLQLambda": {
              "Type": "AWS::Lambda::Function",
              "DependsOn": [
                  "SumoCWLambdaExecutionRole",
                  "SumoCWDeadLetterQueue"
              ],
              "Properties": {
                  "FunctionName": { "Fn::Join": [ "-", [ "SumoCWProcessDLQLambda", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] },
                  "Code": {
                      "S3Bucket": { "Fn::FindInMap" : [ "RegionMap", { "Ref" : "AWS::Region" }, "bucketname"]},
                      "S3Key": "cloudwatchlogs-with-dlq.zip"
                  },
                  "Role": {
                      "Fn::GetAtt": [
                          "SumoCWLambdaExecutionRole",
                          "Arn"
                      ]
                  },
                  "Timeout": 300,
                  "Handler": "DLQProcessor.handler",
                  "DeadLetterConfig": {
                      "TargetArn" : {
                          "Fn::GetAtt": [
                              "SumoCWDeadLetterQueue",
                              "Arn"
                          ]
                      }
                  },
                  "Runtime": "nodejs14.x",
                  "MemorySize": 128,
                  "Environment": {
                      "Variables": {
                          "SUMO_ENDPOINT": {"Ref": "SumoEndPointURL"},
                          "TASK_QUEUE_URL": {
                              "Fn::Join": [
                                  "",
                                  [
                                    "https://sqs.",
                                    { "Ref" : "AWS::Region" },
                                    ".amazonaws.com/",
                                    { "Ref" : "AWS::AccountId" },
                                    "/",
                                    {"Fn::GetAtt": ["SumoCWDeadLetterQueue", "QueueName"]}
                                  ]
                              ]
                          },
                          "NUM_OF_WORKERS": {"Ref": "NumOfWorkers"},
                          "LOG_FORMAT": {"Ref": "LogFormat"},
                          "INCLUDE_LOG_INFO": {"Ref": "IncludeLogGroupInfo"},
                          "LOG_STREAM_PREFIX": {"Ref": "LogStreamPrefix"}
                      }
                  }
              }
          },
          "SumoCWEmailSNSTopic": {
              "Type":"AWS::SNS::Topic",
              "Properties":{
                  "Subscription":[ {
                      "Endpoint" : {"Ref": "EmailID"},
                      "Protocol" : "email"
                  }]
              }
          },
          "SumoCWSpilloverAlarm":{
              "Type":"AWS::CloudWatch::Alarm",
              "Properties":{
                  "AlarmActions":[
                      {
                          "Ref":"SumoCWEmailSNSTopic"
                      }
                  ],
                  "AlarmDescription":"Notify via email if number of messages in DeadLetterQueue exceeds threshold",
                  "ComparisonOperator":"GreaterThanThreshold",
                  "Dimensions":[
                      {
                          "Name": "QueueName",
                          "Value": {"Fn::GetAtt": ["SumoCWDeadLetterQueue", "QueueName"]}
                      }
                  ],
                  "EvaluationPeriods":"1",
                  "MetricName":"ApproximateNumberOfMessagesVisible",
                  "Namespace":"AWS/SQS",
                  "Period":"3600",
                  "Statistic":"Sum",
                  "Threshold":"1"
              },
              "DependsOn": ["SumoCWEmailSNSTopic"]
          }
      },
      "Outputs": {
          "SumoCWLogsLambdaArn" : {
              "Description": "The ARN of the sumologic cloudwatch logs lambda",
              "Value" : { "Fn::GetAtt" : ["SumoCWLogsLambda", "Arn"] },
              "Export" : {
                  "Name" : { "Fn::Join": [ "-", [ "SumoCWLogsLambdaArn", { "Fn::Select" : [ "2", {"Fn::Split" : [ "/" , { "Ref": "AWS::StackId" } ]}] } ] ] }

              }
          }
      }
  }
  EOT
}