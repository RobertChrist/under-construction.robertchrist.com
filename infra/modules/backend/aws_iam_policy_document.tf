# ----------------------- Individual Statements ----------------------

data "aws_iam_policy_document" "sns_topic__allow_publish" {
  statement {
    actions       = ["SNS:Publish"]
    effect        = "Allow"
    sid           = "VisualEditor0"
    resources     = ["arn:aws:sns:${var.aws_region}:${var.aws_account_id}:*"]
  }
}

data "aws_iam_policy_document" "sns_topic__allow_publish_for_api_gateway" {
  statement {
    actions       = ["SNS:Publish"]
    effect        = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    sid           = "AWS-ApiGateway"
    resources     = ["arn:aws:sns:${var.aws_region}:${var.aws_account_id}:*"]
  }
}

data "aws_iam_policy_document" "sns_topic__allow_all_rights_for_owner_account" {
  statement {
    actions         = ["SNS:Subscribe",
                       "SNS:SetTopicAttributes",
                       "SNS:RemovePermission",
                       "SNS:Publish",
                       "SNS:ListSubscriptionsByTopic",
                       "SNS:GetTopicAttributes",
                       "SNS:DeleteTopic",
                       "SNS:AddPermission"]
    effect        = "Allow"      
    principals {
      type        = "AWS"
      identifiers = ["*"]
    } 
    condition {
      test        = "StringEquals"
      variable    = "AWS:SourceOwner"
      values      = [var.aws_account_id]
    }
    sid           = "__default_statement_ID"
    resources     = ["arn:aws:sns:${var.aws_region}:${var.aws_account_id}:*"]
  }
} 


data "aws_iam_policy_document" "cloudwatch__log_group__allow_create" {
  statement {
    actions           = ["logs:CreateLogGroup"]
    effect            = "Allow"
    resources         = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:*"]
  }
}


data "aws_iam_policy_document" "cloudwatch__log_stream__allow_create_put_on_lambda_groups" {
  statement {
    actions          = ["logs:CreateLogStream", "logs:PutLogEvents"]
    effect          = "Allow"
    resources       = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/lambda/*"]
  }
}

data "aws_iam_policy_document" "cloudwatch__sns_sms_success_logs" {
  statement {
    actions          = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    effect          = "Allow"
    resources       = ["*"]
  }
}

data "aws_iam_policy_document" "api_gateway__assume_role" {
  statement {
    actions         = ["sts:AssumeRole"]
    effect          = "Allow"
    principals {
        type        = "Service"
        identifiers = ["apigateway.amazonaws.com"]
      }
    sid             = ""
  }
}

data "aws_iam_policy_document" "lambda__assume_role" {
  statement {
    actions         = ["sts:AssumeRole"]
    effect          = "Allow"
    principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }
    sid             = ""
  }
}

data "aws_iam_policy_document" "sns__assume_role" {
  statement {
    actions         = ["sts:AssumeRole"]
    effect          = "Allow"
    principals {
        type        = "Service"
        identifiers = ["sns.amazonaws.com"]
      }
    sid             = ""
  }
}

# ----------------------- Compound Statements ----------------------

data "aws_iam_policy_document" "sns_topic__allow_publish_for_api_gateway_or_owner_account" {
  policy_id               =  "__default_policy_ID"
  source_policy_documents = [
    data.aws_iam_policy_document.sns_topic__allow_publish_for_api_gateway.json,
    data.aws_iam_policy_document.sns_topic__allow_all_rights_for_owner_account.json
  ]
}

data "aws_iam_policy_document" "cloudwatch__allow_log_group_and_streams__for_lambda_log_groups" {
  source_policy_documents = [
    data.aws_iam_policy_document.cloudwatch__log_group__allow_create.json,
    data.aws_iam_policy_document.cloudwatch__log_stream__allow_create_put_on_lambda_groups.json
  ]
}