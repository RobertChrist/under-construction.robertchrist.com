const config = require('dotenv').config();
const chromium = require('chrome-aws-lambda');
const {google} = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const submitFormTest = require('./src/tests/submitFormTest');
const submitErrorTest = require('./src/tests/submitErrorTest');

const ensureConfig = () => {
  if (config.error)
      throw config.error;
};

const delay = (ms) => new Promise((res) => setTimeout(res, ms));

const getGmailOAuthClient = (env) => {
  const oauth2Client = new OAuth2(
      env.clientId,
      env.clientSecret,
      'https://developers.google.com/oauthplayground',
  );

  oauth2Client.setCredentials({
      refresh_token: env.refreshToken,
  });

  return oauth2Client;
};

const wrap = async (f) => {
  try {
    return await f();
  } catch (ex) {
    console.error(ex);
    return false;
  }
};

const runTests = async (oAuth, page) => {
  await wrap(async () => await submitFormTest.act(page));
  await wrap(async () => await submitErrorTest.act(page));

  // let the pipelines execute
  await delay(1000 * 60 * .5);

  const results = [];
  results.push(await wrap(async () => await submitFormTest.assert(oAuth)));
  results.push(await wrap(async () => await submitErrorTest.assert(oAuth)));

  const failures = [];
  for (let i = 0; i < results.length; i++) {
    if (!results[i])
      failures.push(i);
  }

  return {
    'success': results.every((v) => v),
    'failedTests': failures,
  };
};

exports.handler = async (context, event) => {
  let browser;

  try {
    ensureConfig();

    const oAuthClient = getGmailOAuthClient(process.env);
    browser = await chromium.puppeteer.launch({
      args: chromium.args,
      defaultViewport: chromium.defaultViewport,
      executablePath: await chromium.executablePath,
      headless: chromium.headless,
      ignoreHTTPSErrors: true,
    });

    const page = await browser.newPage();
    await page.goto(process.env.url);

    const res = await runTests(oAuthClient, page);
    res.success ? console.log('All Integration Tests Succeeded!')
                : console.log('Integration Test Failure!  Failed Test indicies: ' + JSON.stringify(res.failedTests));

  } catch (err) {
    console.error(err);
  } finally {
    if (browser)
      await browser.close();
  }
};