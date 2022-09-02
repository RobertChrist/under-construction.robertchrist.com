const {doesSingleMessageExist} = require('../queryGmail');

const submitError = async (page) => {
  await page.evaluate(async () => {
    await window.contactForm.logError(new Error('Integration Test Example Error'));
  });
};

const readMail = async (gmailAuth) => {
  return await doesSingleMessageExist(gmailAuth, 'from:no-reply@sns.amazonaws.com '
                                      + '"Integration Test Example Error"', new Date());
};

module.exports = {
  act: submitError,
  assert: readMail,
};