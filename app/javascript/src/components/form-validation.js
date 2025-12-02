/**
 * Form Validation Component
 * Turbo-aware Bootstrap form validation
 */

const formValidation = (() => {
  const initialize = () => {
    for (const form of document.getElementsByClassName("needs-validation")) {
      if (form.dataset.validationAttached === "true") continue;

      form.addEventListener(
        "submit",
        (e) => {
          if (!form.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
          }
          form.classList.add("was-validated");
        },
        false
      );

      form.dataset.validationAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default formValidation;
