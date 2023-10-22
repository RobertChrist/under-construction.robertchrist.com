import SnackBar from './SnackBar';
import logError from '../logError';

const delay = (ms) => new Promise((res) => setTimeout(res, ms));

class ContactForm {
  #config; #windowRef; #container; #form; #fieldSet; #loadingIcon; #snackBar;
  #cssConfig = {
    formContainer: 'contact-form',
    submittedAttr: 'contact-form--submitted',
    contactForm: 'contact-form__form',
    loadingIcon: 'contact-form__loading',
    loadingIconVisibleAttr: 'contact-form__loading--active',
    toastContainer: 'contact-form__toast-container',
  };

  constructor(config, windowRef, documentRef) {
    this.#config = config;
    this.#windowRef = windowRef;
    this.#container = documentRef.getElementsByClassName(this.#cssConfig.formContainer)[0];
    this.#form = documentRef.getElementsByClassName(this.#cssConfig.contactForm)[0];
    this.#fieldSet = this.#form.children[0];
    this.#loadingIcon = documentRef.getElementsByClassName(this.#cssConfig.loadingIcon)[0];

    const toastContainer = documentRef.getElementsByClassName(this.#cssConfig.toastContainer)[0];
    this.#snackBar = new SnackBar(toastContainer, this.#windowRef);
  }

  attach() {
    this.#setContactFormHeight();

    this.#form.addEventListener('submit', async (event) => {
      event.preventDefault();

      await this.#submitForm();
    }, true);
  }

  async #submitForm() {
    try {
      const data = new FormData(this.#form);
      data.append('callingApp', this.#config.appName);

      this.#setFormStatus(false);

      const temp = {};
      data.forEach(function(value, key) {
        temp[key] = value;
      });

      const response = await fetch(this.#config.contactFormUri, {
        method: 'post',
        mode: 'cors',
        // body: JSON.stringify(Object.fromEntries(data)), babel doesn't polyfill fromEntries consistently. 1/14/2022
        body: JSON.stringify(temp),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': this.#config.apiKey,
        },
      });

      if (!response.ok)
        throw new Error(response.status + ': ' + response.message);

      if (this.#snackBar.purgeToasts())
        await delay(1000); // Give the UI some time to animate the toast purge

      this.#snackBar.addToast('Message successfully submitted! Thank you!', true);
      this.#container.classList.add(this.#cssConfig.submittedAttr);

    } catch (err) {
      this.#snackBar.addToast('Message Failed to Deliver', false);

      const loggedSuccessfully = await logError(this.#config, err);

      if (!loggedSuccessfully) {
        this.#snackBar.addToast('Unable to Log Error to Website.');

        await delay(820); // I've found that adding a delay here is aesthetically pleasing.

        this.#snackBar.addToast('Please let me know via Contact@RobertChrist.com.  Sorry!', false);
      }
    }

    this.#setFormStatus(true);
  }

  #setFormStatus(isEnabled) {
    isEnabled ? this.#fieldSet.removeAttribute('disabled') : this.#fieldSet.setAttribute('disabled', true);
    isEnabled ? this.#loadingIcon.classList.remove(this.#cssConfig.loadingIconVisibleAttr)
              : this.#loadingIcon.classList.add(this.#cssConfig.loadingIconVisibleAttr);
  }

  // On small displays, we want our toasts to cause the layout to flow as per css rules.
  // On large displays, there is enough empty space for the toasts to list without rearranging
  //    other page features.  So we lock the section height.
  #setContactFormHeight() {
    const height = this.#form.getBoundingClientRect()?.height;

    if (height && this.#windowRef.matchMedia('(min-width: 1600px)').matches)
      this.#container.style.height = height;
  }
}

export default ContactForm;