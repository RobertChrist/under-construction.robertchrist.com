#### **View This Repository Live at [RobertChrist.com](https://robertchrist.com)**

# Under Construction

This repository was a personal learning refresher in what is required to host a fully functional, serverless website in 2022.  I have chosen to make it public in order to reference it in examples during discussions on the trade-offs between different types of web application architectures.

The website in question is a straight forward "This Page is Under Construction" style website, complete with an animated background and an interactive contact request form.  Receiving a contact request form submission sends a notification to AWS SNS, which is configured to automatically notify the website owner of requests and client-side errors via text message and email.  SNS then kicks off a lambda function which uses oAuth to log into a configurable Google Workspace owned Gmail account to send an automatic reply email from a Contact@The-Websites-Domain-Name.com email address.    

All of the above is then tested weekly via integration tests, and monitored via a log ingesting dashboard in SumoLogic, all of which is configured in this repository.

All source code for all of the above, as well as all Cloud component definitions (via Terraform) for all of the above are defined in and are cloneable/deployable from this repository.  Complex components have their own README files explaining information about that module.

## Repository Organization
* `Source` - Application source files are defined in the [`src`](/src) folder.
* `Infrastructure` - Infrastructure components are defined via terraform in the [`infra`](/infra) folder.  See the modules folder for sub-components and relevant README files.
* `Monitoring` - Monitoring the production environment is configured with SumoLogic, which is defined in [`infra/modules/monitoring`](/infra/modules/monitoring).
  * Monitoring queries are defined in [`infra/modules/monitoring/sumologic_dashboard_queries.tf`](/infra/modules/monitoring/sumologic_dashboard_queries.tf)
* `Testing` - The production website and backend pipeline are tested via weekly integration tests.
  * See [`infra/modules/integration_testing`](infra/modules/integration_testing) and [`src/lambda/lambdas/*-IntegrationTest`](src/lambda/lambdas/CWEvent-ContactForm-IntegrationTest)

## CI/CD
Each component in this repository includes deployment scripts and example config files you can use for reference.  I suggest cloning this repository, then modifying it to meet the requirements of the CI/CD and secret management pipeline of your choice. 
  * All components in the [`/src`](/src) folder use .env files symlinked to a nonexistent Secrets directory.  Replace these symlinks with .env files of your own, using the provided .env.example files for reference.
  * [`/infra/provider.tf`](/infra/provider.tf) defines the terraform state file, and cloud credentials files to exist in the nonexistent secrets folder.  Replace these with your own provider credentials and desired tfState location/backend, then run `terraform init`.
  * `/infra/secrets.auto.tfvars` - Is a smylink to a file to the nonexistent Secrets directory with the same path.  Replace this file with a new auto.tfvars file using [`/infra/variables.tf`](/infra/variables.tf) as a reference.

## Source Files
All project source files are found in the project's [/src](/src) folder.

Each component in the project is lintable, buildable, and deployable from that component's defined **npm scripts**.

* **src/site** 
The website uses sass and postcss for pre and postprocessing css respectively, and uses webpack with babel for managing javascript and local development.  As this is a very simple website, no front-end frameworks are used.
The website itself is a static website, that deploys to an AWS S3 bucket and is accessed via a CloudFront distribution.

* **src/lambdas/lambda/SNSListener-ContactForm-Emailer**
This lambda function will use oAuth to log into a Gmail account, and send an email notification when triggered.  
This lambda is meant more as a template for use than as an actual feature, as I expect most of versions of this website will desire to send some form of "Message Received" email from a Contact@DomainName.com address to anyone who contacts the website owner via the website-based contact form.  
In the currently deployed version of this website, this lambda emails myself personally with a custom message, to notify me of a contact request, instead of sending the user an automatic response.

* **src/lambda/lambdas/CWEvent-ContactForm-IntegrationTester**
This lambda runs once a week, triggered via CloudWatch Events (Amazon EventBridge).  This lambda runs an integration test on the website, by using a lambda layer to spin up a Chrome browser instance, navigate to the website in its production environment, submit a contact request and an error, then check that email notifications about both of these events exist in a pre-configured email address.  
This both ensures that the website is working in production, and ensures that the backend pipeline is in working order.

## Infrastructure

All project infrastructure is defined and managed by the Terraform files found in the [/infra](/infra) folder.

Each module in the `infra` folder includes a README that contains additional information about its architecture, and documents any manual steps that must be managed outside of terraform in order to deploy the module.

* **Website** 
This module is responsible for all infrastructure related to hosting the website.

* **Backend**
This module is responsible for hosting all of our serverless components.

* **Email**
This module is responsible for all configuration required to own an oAuth accessible Gmail account on a custom domain name.  The domain name is configured to be the same domain name as defined in the website module.  This is the email address used by SNSListener-ContactForm-Emailer above.  GCP and Google Workspace are leveraged to meet these requirements.

  * **email_custom_domain**
This sub-module is responsible for managing all configuration required to allow Gmail (via GoogleWorkspace) to send and receive emails from our website's custom domain.

  * **email_oAuth_access**
This sub-module is responsible for managing all configuration required to allow oAuth access to a Gmail account managed by the above Google Workspace account.

* **Monitoring**
This module is responsible for defining all CloudWatch and CloudFront logs, ensuring they are ingested into SumoLogic, then creating and configuring a SumoLogic dashboard to allow for monitoring of the Production environment.

* **Integration_Testing**
This module is responsible for all configuration required to run weekly integration tests on the live production website and pipeline.

## Security
  This website generates a publicly accessible api to allow website visitors to leave contact messages for the website owner.
  These rate-limited and capped requests are required to include a secret key, which can be rotated quickly via terraform command.
  Google Recaptcha has also been implemented to give a configurable second layer of defense.

## Compatibility
This website was manually tested and verified on a wide range of physical devices.

* This website was tested successfully on multiple devices on the following product lines:
    * Windows - **Windows XP Firefox 52** through **Windows 10 Firefox 96**
    * Mac - **Mac Mountain Lion** through **Monterray** on Firefox 52+, Safari, Chrome, Opera and Edge    
    * iPhone - **iPhone 7** through **iPhone 13** - Safari, Chrome
    * iPad - **iPad Pro 11 (2018)** through **iPad Pro 12.9 (2021)** - Safari, Chrome
    * Samsung Android - **Samsung S8** through **S20** - Samsung Internet, Chrome, Firefox
    * Sony Xperia - **Sony Xperia z5** - Chrome
    * Huawui - **Huawei P30** - Chrome, Firefox

* This website was tested to ensure graceful degradation on the legacy browsers listed below.  These browsers were tested on numerous devices, the oldest of which were released between 2014-2016.
    * **Samsung S8 - UC Browser and older**
    * **Chrome** <= 62
    * **Yandex** 14.12
    * **Firefox** <= 47