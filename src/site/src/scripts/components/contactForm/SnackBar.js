class SnackBar {
  #cssConfig = {
    toastContent: 'contact-form__toast-message',
    toast: 'contact-form__toast',
    successAttr: 'contact-form__toast--success',
    errorAttr: 'contact-form__toast--error',
    deletingAttr: 'contact-form__toast--deleting',
    transitionToNewBottomAttr: 'contact-form__toast--new-bottom',
  };

  #toastContainer; #windowRef; #currentToasts;

  constructor(toastContainerElem, windowRef) {
    this.#toastContainer = toastContainerElem;
    this.#windowRef = windowRef;
    this.#currentToasts = [];
  }

  addToast(message, isSuccess) {
    const msgToAdd = this.#getMessageHtml(message, isSuccess);

    this.#toastContainer.insertAdjacentHTML('afterbegin', msgToAdd);

    const newlyAddedElem = this.#toastContainer.firstChild;

    this.#currentToasts.push(newlyAddedElem);

    if (!isSuccess)
      this.#windowRef.setTimeout(() => this.#deleteToast(newlyAddedElem), 1000 * 10);
  }

  purgeToasts() {
    const numPurged = this.#currentToasts.length;

    for (const toast of this.#currentToasts)
      this.#innerDelete(toast);

    this.#currentToasts = [];

    return numPurged;
  }

  #deleteToast(elem) {
    this.#currentToasts = this.#currentToasts.filter((t) => t != elem);

    this.#innerDelete(elem);
  }

  #innerDelete(elem) {
    elem.classList.add(this.#cssConfig.deletingAttr);

    const prevSibling = elem.previousSibling;
    if (prevSibling)
      prevSibling.classList.add(this.#cssConfig.transitionToNewBottomAttr);

    // we give a 1 second delay, to allow the css transitions for transitionToNewBottomAttr to display.
    this.#windowRef.setTimeout(() => elem.remove(), 1000 * 1);
  }

  #getMessageHtml(message, isSuccess) {
    const statusClass = isSuccess ? this.#cssConfig.successAttr : this.#cssConfig.errorAttr;

    return '<div class="' + this.#cssConfig.toast + ' ' + statusClass + '">'
      + '<div class=" ' + this.#cssConfig.toastContent + '" >' + message + '</div>' + '</div>';
  }
}

export default SnackBar;