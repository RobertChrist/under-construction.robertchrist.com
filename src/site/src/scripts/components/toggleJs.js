function enable() {
  document.body.classList.replace('js-off', 'js-on');
}

function disable() {
  document.body.classList.replace('js-on', 'js-off');
}

function displayErrorMessage(message) {
  disable();
  const span = document.querySelector('contact-form__no-script-display span');
  span.innerHTML = message;
}

export default {
  enable,
  disable,
  displayErrorMessage,
};