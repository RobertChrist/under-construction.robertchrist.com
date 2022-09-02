## Overview

This module is responsible for all configuration required to run weekly integration tests on the live production website and ensure our backend pipeline is in working order.

## Architecture
* **Cloudwatch Events**
A weekly Cloudwatch Event is used to trigger our lambda function.

* **Lambda Layers**
A custom lambda layer is configured, which [../src/lambda/lambda-layers](../src/lambda/lambda-layers) uses to host puppeteer.

* **Lambda**
An AWS lambda is configured for use by [../src/lambda/lambda/CWEvent-ContactForm-IntegrationTest](../src/lambda/lambda/CWEvent-ContactForm-IntegrationTest), to run an automated integration test against the public website, and api gateway endpoints.

The results of this test are then viewable in the Monitoring dashboard configured in [../monitoring](../monitoring).