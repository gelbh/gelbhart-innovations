/**
 * Toast
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://getbootstrap.com
 */

const toast = (() => {
  // Store toast instances for cleanup
  let toastInstances = [];

  function initialize() {
    // Dispose existing toasts to prevent duplicates
    toastInstances.forEach((toast) => {
      if (toast && typeof toast.dispose === "function") {
        toast.dispose();
      }
    });
    toastInstances = [];

    const toastElList = [].slice.call(document.querySelectorAll(".toast"));

    /* eslint-disable no-unused-vars, no-undef */
    toastInstances = toastElList.map((toastEl) => new bootstrap.Toast(toastEl));
    /* eslint-enable no-unused-vars, no-undef */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache
  document.addEventListener("turbo:before-cache", () => {
    toastInstances.forEach((toast) => {
      if (toast && typeof toast.dispose === "function") {
        toast.dispose();
      }
    });
    toastInstances = [];
  });
})();

export default toast;
