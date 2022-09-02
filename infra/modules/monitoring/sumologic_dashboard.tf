resource "sumologic_dashboard" "project_dashboard" {
  title               = var.project_name
  folder_id           = data.sumologic_personal_folder.personal_folder.id
  refresh_interval    = 120
  theme               = "Light"
  
  time_range {
    begin_bounded_time_range {
      from {
        relative_time_range {
          relative_time = "-1w"
        }
      }
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Unique Visitors"
      key = "panel_cloudfront_unique_visitors"
      query {
        query_key = "A"
        query_type = "Logs"
        query_string = local.queries.cloudfront_unique_visitors
      }
      visual_settings = "{\"general\":{\"displayType\":\"default\",\"mode\":\"singleValueMetrics\",\"type\":\"svp\"},\"series\":{},\"svp\":{\"gauge\":{\"max\":100,\"min\":0,\"show\":false,\"showThreshold\":false,\"showThresholdMarker\":false},\"hideData\":false,\"hideLabel\":false,\"label\":\"Unique Visitors\",\"labelFontSize\":14,\"noDataString\":\"0\",\"option\":\"Latest\",\"rounding\":2,\"sparkline\":{\"color\":\"#222D3B\",\"show\":false},\"thresholds\":[{\"color\":\"#16943E\",\"from\":1,\"to\":null},{\"color\":\"#DFBE2E\",\"from\":null,\"to\":null},{\"color\":\"#BF2121\",\"from\":null,\"to\":null}],\"useBackgroundColor\":false,\"useNoData\":false,\"valueFontSize\":24},\"title\":{\"fontSize\":14}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Requests"
      key = "panel_cloudfront_total_request"
      query {
        query_key = "A"
        query_string = local.queries.cloudfront_requests_time_bucketted
        query_type = "Logs"
      }
      visual_settings = "{\"series\":{},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"color\":{\"family\":\"Categorical Default\"},\"legend\":{\"enabled\":false},\"overrides\":[]}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Unique Visitors"
      key = "panel_cloudfront_unique_visitors_bucketted"
      query {
        query_key = "A"
        query_string = local.queries.cloudfront_unique_visitors_time_bucketted
        query_type = "Logs"
      }
      visual_settings = "{\"series\":{},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"color\":{\"family\":\"Categorical Default\"},\"legend\":{\"enabled\":false},\"overrides\":[]}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Status Codes Returned"
      key = "panel_cloudfront_status_codes_returned"
      query {
        query_key = "A"
        query_string = local.queries.cloudfront_status_codes_returned
        query_type = "Logs"
      }
      visual_settings = "{\"series\":{},\"general\":{\"type\":\"pie\",\"displayType\":\"default\",\"fillOpacity\":1,\"startAngle\":270,\"innerRadius\":\"30%\",\"maxNumOfSlices\":10,\"mode\":\"distribution\"}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Status Code Errors"
      key = "panel_cloudfront_status_code_errors"
      query {
        query_key = "A"
        query_string = local.queries.cloudfront_status_code_errors
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"Status Code Errors\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":null,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG - Contact Request Posts - Successful "
      key = "panel_api_gateway_successful_contact_requests"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_contact_request_posts_successful
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"Contact Requests\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":1,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":null,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG- Contact Requests (Post/Opt) - Errors"
      key = "panel_api_gateway_contact_request_errors"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_contact_request_failures
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"Contact Request Errors\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":null,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG - Contact Request - Posts"
      key = "panel_api_gateway_contact_requests_time_buckets"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_contact_request_posts_bucketted
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"column\"},\"series\":{},\"legend\":{\"enabled\":false},\"overrides\":[]}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG - Error Posts - Successful "
      key = "panel_api_gateway_front_end_error_submissions"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_error_posts_successful
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"LogError Posts\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":null,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG - Error Requests (Post/Opt) - Errors"
      key = "panel_api_gateway_front_end_error_submission_errors"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_error_submitted_failures
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"LogError, Errors\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":null,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "AG - Error - Posts"
      key = "panel_api_gateway_errors_bucketted_by_time"
      query {
        query_key = "A"
        query_string = local.queries.api_gateway_error_posts_bucketted
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"column\"},\"series\":{},\"legend\":{\"enabled\":false},\"color\":{\"family\":\"Diverging 2\"},\"overrides\":[]}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "Lambda - Emailer - Errors"
      key = "panel_email_errors"
      query {
        query_key = "A"
        query_string = local.queries.lambda_emailer_errors
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"Email Errors\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":null,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "Lambda - Emailer - Total Attempted Emails"
      key = "panel_email_totals"
      query {
        query_key = "A"
        query_string = local.queries.lambda_emailer_total_attempted_emails
        query_type = "Logs"
      }
      visual_settings = "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"svp\",\"displayType\":\"default\",\"mode\":\"singleValueMetrics\"},\"svp\":{\"option\":\"Latest\",\"label\":\"Total Emails\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":1,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":null,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "Lambda - Emailer"
      key = "panel_email_totals_bucketted_by_time"
      query {
        query_key = "A"
        query_string = local.queries.lambda_emailer_total_attempted_bucketted
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"column\"},\"series\":{},\"legend\":{\"enabled\":false},\"overrides\":[]}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "CloudFront - Error Status Code Paths"
      key = "panel_error_statuses_returned_by_url_path"
      query {
        query_key = "A"
        query_string = local.queries.cloudfront_status_code_error_paths
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"distribution\",\"type\":\"table\"},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "Lambda - Emailer - All Contact Attempts"
      key = "panel_all_contact_request_bodies"
      query {
        query_key = "A"
        query_string = local.queries.lambda_emailer_all_contact_attempts
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"distribution\",\"type\":\"table\"},\"series\":{}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "SMS Texting Failures"
      key = "panel_sms_text_failed_attempts"
      query {
        query_key = "A"
        query_string = local.queries.sms_texting_failures
        query_type = "Logs"
      }
      keep_visual_settings_consistent_with_parent = true
      visual_settings = "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"svp\":{\"option\":\"Latest\",\"label\":\"SMS Failure\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":0,\"to\":0,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{},\"legend\":{\"enabled\":false}}"
    }
  }

  panel {
    sumo_search_panel {
      title = "Successful Integration Tests"
      key = "panel_successful_intergration_tests"
      query {
        query_key = "A"
        query_string = local.queries.successful_integration_tests
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"svp\":{\"option\":\"Latest\",\"label\":\"Successful Tests\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":1,\"to\":null,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":0,\"to\":1,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{},\"legend\":{\"enabled\":false}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }

  panel {
    sumo_search_panel {
      title = "Failed Integration Tests"
      key = "panel_failed_integration_tests"
      query {
        query_key = "A"
        query_string = local.queries.failed_integration_tests
        query_type = "Logs"
      }
      visual_settings = "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"svp\":{\"option\":\"Latest\",\"label\":\"Failed Tests\",\"useBackgroundColor\":false,\"useNoData\":false,\"noDataString\":\"0\",\"hideData\":false,\"hideLabel\":false,\"rounding\":2,\"valueFontSize\":24,\"labelFontSize\":14,\"thresholds\":[{\"from\":0,\"to\":1,\"color\":\"#16943E\"},{\"from\":null,\"to\":null,\"color\":\"#DFBE2E\"},{\"from\":1,\"to\":null,\"color\":\"#BF2121\"}],\"sparkline\":{\"show\":false,\"color\":\"#222D3B\"},\"gauge\":{\"show\":false,\"min\":0,\"max\":100,\"showThreshold\":false,\"showThresholdMarker\":false}},\"series\":{},\"legend\":{\"enabled\":false}}"
      keep_visual_settings_consistent_with_parent = true
    }
  }
  
  layout {
    grid {
      layout_structure {
        key = "panel_cloudfront_unique_visitors"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":6}"
      }

      layout_structure {
        key = "panel_cloudfront_total_request"
        structure = "{\"height\":6,\"width\":8,\"x\":14,\"y\":6}"
      }

      layout_structure {
        key = "panel_cloudfront_unique_visitors_bucketted"
        structure = "{\"height\":6,\"width\":8,\"x\":6,\"y\":6}"
      }

      layout_structure {
        key = "panel_cloudfront_status_codes_returned"
        structure = "{\"height\":6,\"width\":8,\"x\":6,\"y\":12}"
      }

      layout_structure {
        key = "panel_cloudfront_status_code_errors"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":12}"
      }

      layout_structure {
        key = "panel_api_gateway_successful_contact_requests"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":18}"
      }

      layout_structure {
        key = "panel_api_gateway_contact_request_errors"
        structure = "{\"height\":6,\"width\":6,\"x\":6,\"y\":18}"
      }

      layout_structure {
        key = "panel_api_gateway_contact_requests_time_buckets"
        structure = "{\"height\":6,\"width\":12,\"x\":12,\"y\":18}"
      }

      layout_structure {
        key = "panel_api_gateway_front_end_error_submissions"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":24}"
      }

      layout_structure {
        key = "panel_api_gateway_front_end_error_submission_errors"
        structure = "{\"height\":6,\"width\":6,\"x\":6,\"y\":24}"
      }

      layout_structure {
        key = "panel_api_gateway_errors_bucketted_by_time"
        structure = "{\"height\":6,\"width\":12,\"x\":12,\"y\":24}"
      }

      layout_structure {
        key = "panel_email_errors"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":30}"
      }

      layout_structure {
        key = "panel_email_totals"
        structure = "{\"height\":6,\"width\":6,\"x\":6,\"y\":30}"
      }

      layout_structure {
        key = "panel_email_totals_bucketted_by_time"
        structure = "{\"height\":6,\"width\":12,\"x\":12,\"y\":30}"
      }

      layout_structure {
        key = "panel_error_statuses_returned_by_url_path"
        structure = "{\"height\":6,\"width\":8,\"x\":14,\"y\":12}"
      }

      layout_structure {
        key = "panel_all_contact_request_bodies"
        structure = "{\"height\":6,\"width\":12,\"x\":6,\"y\":36}"
      }

      layout_structure {
        key = "panel_sms_text_failed_attempts"
        structure = "{\"height\":6,\"width\":6,\"x\":0,\"y\":36}"
      }

      layout_structure {
        key = "panel_successful_intergration_tests"
        structure = "{\"height\":6,\"width\":9,\"x\":0,\"y\":0}"
      }

      layout_structure {
        key = "panel_failed_integration_tests"
        structure = "{\"height\":6,\"width\":8,\"x\":9,\"y\":0}"
      }
    }
  }
}