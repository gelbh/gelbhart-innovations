/**
 * Toggling password visibility in password input
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const passwordVisibilityToggle = (() => {
  function initialize() {
    const elements = document.querySelectorAll(".password-toggle");

    for (let i = 0; i < elements.length; i++) {
      // Skip if already has listener attached
      if (elements[i].dataset.passwordToggleAttached === "true") continue;

      const passInput = elements[i].querySelector(".form-control");
      const passToggle = elements[i].querySelector(".password-toggle-btn");

      if (!passInput || !passToggle) continue;

      passToggle.addEventListener(
        "click",
        (e) => {
          if (e.target.type !== "checkbox") return;
          if (e.target.checked) {
            passInput.type = "text";
          } else {
            passInput.type = "password";
          }
        },
        false
      );

      elements[i].dataset.passwordToggleAttached = "true";
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default passwordVisibilityToggle;
