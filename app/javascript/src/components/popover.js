/**
 * Popover
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://getbootstrap.com
 * @requires https://popper.js.org/
 */

const popover = (() => {
  // Store popover instances for cleanup
  let popoverInstances = [];

  function initialize() {
    // Dispose existing popovers to prevent duplicates
    popoverInstances.forEach((popover) => {
      if (popover && typeof popover.dispose === "function") {
        popover.dispose();
      }
    });
    popoverInstances = [];

    const popoverTriggerList = [].slice.call(
      document.querySelectorAll('[data-bs-toggle="popover"]')
    );

    /* eslint-disable no-unused-vars, no-undef */
    popoverInstances = popoverTriggerList.map(
      (popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl)
    );
    /* eslint-enable no-unused-vars, no-undef */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache to prevent stale popovers
  document.addEventListener("turbo:before-cache", () => {
    popoverInstances.forEach((popover) => {
      if (popover && typeof popover.dispose === "function") {
        popover.dispose();
      }
    });
    popoverInstances = [];
  });
})();

export default popover;
