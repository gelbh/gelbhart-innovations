/**
 * Form validation
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const formValidation = (() => {
  const selector = "needs-validation";

  function initialize() {
    // Fetch all the forms we want to apply custom Bootstrap validation styles to
    const forms = document.getElementsByClassName(selector);

    // Loop over them and prevent submission
    /* eslint-disable no-unused-vars */
    const validation = Array.prototype.filter.call(forms, (form) => {
      // Skip if already has validation listener attached
      if (form.dataset.validationAttached === "true") return;

      form.addEventListener(
        "submit",
        (e) => {
          if (form.checkValidity() === false) {
            e.preventDefault();
            e.stopPropagation();
          }
          form.classList.add("was-validated");
        },
        false
      );

      form.dataset.validationAttached = "true";
    });
    /* eslint-enable no-unused-vars */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default formValidation;
