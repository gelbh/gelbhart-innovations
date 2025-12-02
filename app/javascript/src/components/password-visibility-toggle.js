/**
 * Password Visibility Toggle Component
 * Turbo-aware password field visibility control
 */

const passwordVisibilityToggle = (() => {
  const initialize = () => {
    for (const el of document.querySelectorAll(".password-toggle")) {
      if (el.dataset.passwordToggleAttached === "true") continue;

      const input = el.querySelector(".form-control");
      const toggle = el.querySelector(".password-toggle-btn");
      if (!input || !toggle) continue;

      toggle.addEventListener(
        "click",
        (e) => {
          if (e.target.type !== "checkbox") return;
          input.type = e.target.checked ? "text" : "password";
        },
        false
      );

      el.dataset.passwordToggleAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default passwordVisibilityToggle;
