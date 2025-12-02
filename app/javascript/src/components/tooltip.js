/**
 * Tooltip
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://getbootstrap.com
 * @requires https://popper.js.org/
 */

const tooltip = (() => {
  // Store tooltip instances for cleanup
  let tooltipInstances = [];

  function initialize() {
    // Dispose existing tooltips to prevent duplicates
    tooltipInstances.forEach((tooltip) => {
      if (tooltip && typeof tooltip.dispose === "function") {
        tooltip.dispose();
      }
    });
    tooltipInstances = [];

    const tooltipTriggerList = [].slice.call(
      document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );

    /* eslint-disable no-unused-vars, no-undef */
    tooltipInstances = tooltipTriggerList.map(
      (tooltipTriggerEl) =>
        new bootstrap.Tooltip(tooltipTriggerEl, { trigger: "hover" })
    );
    /* eslint-enable no-unused-vars, no-undef */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache to prevent stale tooltips
  document.addEventListener("turbo:before-cache", () => {
    tooltipInstances.forEach((tooltip) => {
      if (tooltip && typeof tooltip.dispose === "function") {
        tooltip.dispose();
      }
    });
    tooltipInstances = [];
  });
})();

export default tooltip;
