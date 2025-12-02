/**
 * Ajaxify MailChimp subscription form
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const subscriptionForm = (() => {
  function initialize() {
    const forms = document.querySelectorAll(".subscription-form");

    if (forms === null) return;

    for (let i = 0; i < forms.length; i++) {
      const form = forms[i];

      // Skip if already has listener attached
      if (form.dataset.subscriptionAttached === "true") continue;

      const button = form.querySelector('button[type="submit"]');
      const buttonText = button.innerHTML;
      const input = form.querySelector(".form-control");
      const antispam = form.querySelector(".subscription-form-antispam");
      const status = form.querySelector(".subscription-status");

      form.addEventListener("submit", function (e) {
        if (e) e.preventDefault();
        if (antispam.value !== "") return;
        register(this, button, input, buttonText, status);
      });

      form.dataset.subscriptionAttached = "true";
    }
  }

  const register = (form, button, input, buttonText, status) => {
    button.innerHTML = "Sending...";

    // Get url for MailChimp
    const url = form.action.replace("/post?", "/post-json?");

    // Add form data to object
    const data = "&" + input.name + "=" + encodeURIComponent(input.value);

    // Create and add post script to the DOM
    const script = document.createElement("script");
    script.src = url + "&c=callback" + data;
    document.body.appendChild(script);

    // Callback function
    const callback = "callback";
    window[callback] = (response) => {
      // Remove post script from the DOM
      delete window[callback];
      document.body.removeChild(script);

      // Change button text back to initial
      button.innerHTML = buttonText;

      // Display content and apply styling to response message conditionally
      if (response.result == "success") {
        input.classList.remove("is-invalid");
        input.classList.add("is-valid");
        status.classList.remove("status-error");
        status.classList.add("status-success");
        status.innerHTML = response.msg;
        setTimeout(() => {
          input.classList.remove("is-valid");
          status.innerHTML = "";
          status.classList.remove("status-success");
        }, 6000);
      } else {
        input.classList.remove("is-valid");
        input.classList.add("is-invalid");
        status.classList.remove("status-success");
        status.classList.add("status-error");
        status.innerHTML = response.msg.substring(4);
        setTimeout(() => {
          input.classList.remove("is-invalid");
          status.innerHTML = "";
          status.classList.remove("status-error");
        }, 6000);
      }
    };
  };

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default subscriptionForm;
