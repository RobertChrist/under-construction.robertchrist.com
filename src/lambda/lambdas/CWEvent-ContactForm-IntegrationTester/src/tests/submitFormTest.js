const {doesSingleMessageExist} = require('../queryGmail');

const submitContactForm = async (page) => {
  await page.type('#name', 'Integration Tester');
  await page.type('#email', 'IntegrationTestExampleEmail@RobertChrist.com');
  const date = new Date();
  await page.type('#message', 'Integration test for ' + date.toLocaleDateString() + ' ' + date.toLocaleTimeString());

  await page.click('input[type=submit');

  await Promise.race([
    page.waitForSelector('.contact-form__toast--error'),
    page.waitForSelector('.contact-form__toast--success'),
  ]);

  /* await page.screenshot({
    path: 'sc.png'
  }); */
};


const readMail = async (gmailAuth) => {
  return await doesSingleMessageExist(gmailAuth, 'is:sent "Integration Tester has '
                                      + 'sent you a contact request"', new Date());
};

module.exports = {
  act: submitContactForm,
  assert: readMail,
};