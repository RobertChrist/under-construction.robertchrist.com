import toggleJs from './components/toggleJs';
import animateBackgroundImages from './components/animateBackgroundImages';
import ContactForm from './components/contactForm/ContactForm';
import Config from './components/Config';
import logError from './components/logError';

const convertErr = (err) => {
  try {
    return err instanceof Error ? err : new Error(JSON.stringify(err));
  } catch (typeError) {
    return typeError;
  }
};

(() => {
  const config = new Config(location.hostname);

  try {
    toggleJs.enable();
    animateBackgroundImages();
    new ContactForm(config, window, document, window.grecaptcha).attach();
  } catch (err) {
    toggleJs.displayErrorMessage('Apologies, This Widget Appears to be Incompatible with your Browser.');
    logError(config, convertErr(err));
  }

  // Expose our log error function, so our integration test runner can test our error logging pipeline.
  /* eslint-disable-next-line */
  window.contactForm = { 'logError': (error) => { logError(config, error); }};
})();