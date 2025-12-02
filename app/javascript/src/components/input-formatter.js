/**
 * Input Formatter Component
 * @requires Cleave.js
 * Turbo-aware input field formatting
 */

const inputFormatter = (() => {
  const initialize = () => {
    for (const input of document.querySelectorAll("[data-format]")) {
      if (input.dataset.cleaveAttached === "true") continue;

      const options = input.dataset.format
        ? JSON.parse(input.dataset.format)
        : {};
      const cardIcon = input.parentNode.querySelector(".credit-card-icon");

      if (cardIcon) {
        new Cleave(input, {
          ...options,
          onCreditCardTypeChanged: (type) => {
            cardIcon.className = `credit-card-icon ${type}`;
          },
        });
      } else {
        new Cleave(input, options);
      }

      input.dataset.cleaveAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default inputFormatter;
