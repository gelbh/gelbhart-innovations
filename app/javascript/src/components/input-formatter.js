/**
 * Input fields formatter
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/nosir/cleave.js
 */

const inputFormatter = (() => {
  function initialize() {
    const inputs = document.querySelectorAll("[data-format]");

    if (inputs.length === 0) return;

    /* eslint-disable no-unused-vars, no-undef */
    for (let i = 0; i < inputs.length; i++) {
      const targetInput = inputs[i];

      // Skip if already initialized
      if (targetInput.dataset.cleaveAttached === "true") continue;

      const cardIcon =
        targetInput.parentNode.querySelector(".credit-card-icon");
      let options;
      let formatter;

      if (targetInput.dataset.format != undefined) {
        options = JSON.parse(targetInput.dataset.format);
      }

      if (cardIcon) {
        formatter = new Cleave(targetInput, {
          ...options,
          onCreditCardTypeChanged: (type) => {
            cardIcon.className = "credit-card-icon " + type;
          },
        });
      } else {
        formatter = new Cleave(targetInput, options);
      }

      targetInput.dataset.cleaveAttached = "true";
    }
    /* eslint-enable no-unused-vars, no-undef */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default inputFormatter;
