const cssConfig = {
  bgImgElems: 'background__imgHolder',
  visibleAttr: 'background__imgHolder--visible',
  moveAttr: 'background__imgHolder--movement',
  imageCreditText: 'image-credit__text',
  imageCreditHiddenAttr: 'image-credit--hidden',
};

const showPhotoCredit = (photoCredit, creditTxtElem, delay) => {
  creditTxtElem.parentElement.classList.add(cssConfig.imageCreditHiddenAttr);

  if (photoCredit) {
    window.setTimeout(function() {
      creditTxtElem.innerHTML = 'Photo Credit: ' + photoCredit;
      creditTxtElem.parentElement.classList.remove(cssConfig.imageCreditHiddenAttr);
    }, delay ?? 1500);
  }
};

export default () => {
  window.addEventListener('load', async function() {
    const creditText = document.getElementsByClassName(cssConfig.imageCreditText)[0];
    const bgs = document.querySelectorAll('div.' + cssConfig.bgImgElems);
    const cycleTime = 12000;
    let pos = 0,
      lastPos = 0;

    bgs[0].classList.add(cssConfig.visibleAttr);
    bgs[0].classList.add(cssConfig.moveAttr);

    showPhotoCredit(bgs[0]?.dataset?.photographer, creditText, 0);

    setInterval(function() {
      lastPos = pos;
      pos++;

      if (pos >= bgs.length) pos = 0;

      bgs[lastPos].classList.remove(cssConfig.visibleAttr);
      bgs[pos].classList.add(cssConfig.visibleAttr);
      bgs[pos].classList.add(cssConfig.moveAttr);

      showPhotoCredit(bgs[pos]?.dataset?.photographer, creditText);

      window.setTimeout(function() {
        bgs[lastPos].classList.remove(cssConfig.moveAttr);
      }, 3500);
    }, cycleTime);
  });
};