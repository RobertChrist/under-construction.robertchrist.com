class Config {
  constructor(appName) {
    this.contactFormUri = process.env.CONTACT_FORM_URI;
    this.logErrorUri = process.env.LOG_ERROR_URI;
    this.apiKey = process.env.API_KEY;
    this.appName = appName;
    this.grecaptchaApiKey = process.env.GRECAPTCHA_API_KEY;
  }
}

export default Config;