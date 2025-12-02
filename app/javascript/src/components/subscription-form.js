/**
 * Subscription Form Component
 * Turbo-aware MailChimp subscription form
 */

const subscriptionForm = (() => {
  const STATUS_TIMEOUT = 6000;

  const register = (form, button, input, buttonText, status) => {
    button.innerHTML = "Sending...";

    const url = form.action.replace("/post?", "/post-json?");
    const data = `&${input.name}=${encodeURIComponent(input.value)}`;
    const script = document.createElement("script");
    const callback = "callback";

    script.src = `${url}&c=${callback}${data}`;
    document.body.appendChild(script);

    window[callback] = (response) => {
      delete window[callback];
      document.body.removeChild(script);
      button.innerHTML = buttonText;

      const isSuccess = response.result === "success";
      input.classList.toggle("is-valid", isSuccess);
      input.classList.toggle("is-invalid", !isSuccess);
      status.classList.toggle("status-success", isSuccess);
      status.classList.toggle("status-error", !isSuccess);
      status.innerHTML = isSuccess ? response.msg : response.msg.substring(4);

      setTimeout(() => {
        input.classList.remove("is-valid", "is-invalid");
        status.innerHTML = "";
        status.classList.remove("status-success", "status-error");
      }, STATUS_TIMEOUT);
    };
  };

  const initialize = () => {
    for (const form of document.querySelectorAll(".subscription-form")) {
      if (form.dataset.subscriptionAttached === "true") continue;

      const button = form.querySelector('button[type="submit"]');
      const buttonText = button.innerHTML;
      const input = form.querySelector(".form-control");
      const antispam = form.querySelector(".subscription-form-antispam");
      const status = form.querySelector(".subscription-status");

      form.addEventListener("submit", (e) => {
        e?.preventDefault();
        if (antispam.value) return;
        register(form, button, input, buttonText, status);
      });

      form.dataset.subscriptionAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default subscriptionForm;
