locals {
  whitespace = {
    tab = "\t"
  }

  queries = {
    successful_integration_tests = <<-EOT
      ((_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_integration_test.name}"))
      | where message = "All Integration Tests Succeeded!"
      | count
    EOT

    failed_integration_tests = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_integration_test.name}")
      | where message contains "Fail"
      | count
    EOT

    cloudfront_unique_visitors = <<-EOT
      _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
      | parse regex "(?<cip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+" multi
      | count_distinct(cip)
    EOT

    cloudfront_unique_visitors_time_bucketted = <<-EOT
      _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
      | parse regex "(?<cip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+" multi
      | timeslice 1h
      | count_distinct(cip) by _timeslice
    EOT

    cloudfront_requests_time_bucketted = <<-EOT
     _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
     | parse regex "(?<cip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+" multi
     | timeslice 1h
     | count by _timeslice
    EOT

    cloudfront_status_code_errors = <<-EOT
      _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
      | parse regex "(?<statusCodeRaw>[0-9a-z]\.cloudfront\.net	[^\s]+	\d{3})\s+" multi
      | split statusCodeRaw delim='${local.whitespace.tab}' extract 1 as cloudFrontDistribution, 2 as path, 3 as statusCode
      | where statusCode >= 400
      | count statusCode
    EOT

    cloudfront_status_codes_returned = <<-EOT
      _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
      | parse regex "(?<statusCodeRaw>[0-9a-z]\.cloudfront\.net	[^\s]+	\d{3})\s+" multi
      | split statusCodeRaw delim='${local.whitespace.tab}' extract 1 as cloudFrontDistribution, 2 as path, 3 as statusCode
      | count statusCode
    EOT

    cloudfront_status_code_error_paths = <<-EOT
      _sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_cloudfront_source.aws_cloudfront.name}"
      | parse regex "(?<statusCodeRaw>[0-9a-z]\.cloudfront\.net	[^\s]+	\d{3})\s+" multi
      | split statusCodeRaw delim='${local.whitespace.tab}' extract 1 as cloudFrontDistribution, 2 as path, 3 as statusCode 
      | where statusCode >= 400
      | count group by statusCode, path
      | order by statusCode desc, _count desc
    EOT

    api_gateway_contact_request_posts_successful = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and (_sourceHost="${aws_cloudwatch_log_group.api_gateway_contact_form.name}" or _sourceHost="${aws_cloudwatch_log_group.lambda_integration_test.name}"))
      | if (!isNull(%"message.status"), toLong(%"message.status"), 0) as contactRequestStatus
      | if (message contains "START RequestId: ", 1, 0) as intTest
      | if (%"message.httpMethod" = "POST" AND contactRequestStatus = 200, 1, 0) as contactRequest
      | sum(intTest) as intTot, sum(contactRequest) as contactTot
      | contactTot - intTot as finalTot
      | sum(finalTot)
    EOT

    api_gateway_contact_request_failures = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.api_gateway_contact_form.name}")
      | toLong(%"message.status") as mStatus
      | where mStatus >= 400
      | count
    EOT

    api_gateway_contact_request_posts_bucketted = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.api_gateway_contact_form.name}")
      | toLong(%"message.status") as mStatus
      | where %"message.httpMethod" = "POST"
      | timeslice 1h
      | count _timeslice, mStatus
    EOT

    api_gateway_error_posts_successful = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and (_sourceHost="${aws_cloudwatch_log_group.api_gateway_error_submission.name}" or _sourceHost="${aws_cloudwatch_log_group.lambda_integration_test.name}"))
      | if (!isNull(%"message.status"), toLong(%"message.status"), 0) as contactErrorStatus
      | if (message contains "START RequestId: ", 1, 0) as intTest
      | if (%"message.httpMethod" = "POST" AND contactErrorStatus = 200, 1, 0) as contactError
      | sum(intTest) as intTot, sum(contactError) as errorTot
      | errorTot - intTot as finalTot
      | sum(finalTot)
    EOT

    api_gateway_error_submitted_failures = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.api_gateway_error_submission.name}")
      | toLong(%"message.status") as mStatus
      | where mStatus >= 400
      | count
    EOT

    api_gateway_error_posts_bucketted = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.api_gateway_error_submission.name}")
      | toLong(%"message.status") as mStatus
      | where %"message.httpMethod" = "POST"
      | timeslice 1h
      | count _timeslice, mStatus
    EOT

    lambda_emailer_errors = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_contact_emailer.name}") "Error"
      | count_distinct(logstream)
    EOT

    lambda_emailer_total_attempted_emails = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_contact_emailer.name}")
      | count_distinct(logstream)
    EOT

    lambda_emailer_total_attempted_bucketted = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_contact_emailer.name}")
      | timeslice 1h
      | count_distinct(logstream) by _timeslice
    EOT

    lambda_emailer_all_contact_attempts = <<-EOT
      (_sourceCategory="${sumologic_cloudfront_source.aws_cloudfront.category}" AND _source="${sumologic_http_source.aws_cloudwatch_endpoint.name}" and _sourceHost="${aws_cloudwatch_log_group.lambda_contact_emailer.name}") and "with this data"
      | substring(message, 14) as body
      | formatDate(_messageTime, "MM/dd/yyyy HH:mm:ss:SSS") as timeStamp2
      | count group by timeStamp2, body
      | order by timeStamp2
    EOT

    sms_texting_failures = <<-EOT
      _sourcehost = "${aws_cloudwatch_log_group.sns_sms_direct_publish_failure_logs.name}" 
      | count_distinct(logStream)
    EOT
  }
}