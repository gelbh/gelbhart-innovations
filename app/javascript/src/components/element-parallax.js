/**
 * Element parallax effect
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/dixonandmoe/rellax
 */

const elementParallax = (() => {
  // Store rellax instance for cleanup
  let rellaxInstance = null;

  function initialize() {
    // Destroy existing instance to prevent duplicates
    if (rellaxInstance && typeof rellaxInstance.destroy === "function") {
      rellaxInstance.destroy();
      rellaxInstance = null;
    }

    const el = document.querySelector(".rellax");

    if (el === null) return;

    /* eslint-disable no-unused-vars, no-undef */
    rellaxInstance = new Rellax(".rellax", {
      horizontal: true,
    });
    /* eslint-enable no-unused-vars, no-undef */
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache
  document.addEventListener("turbo:before-cache", () => {
    if (rellaxInstance && typeof rellaxInstance.destroy === "function") {
      rellaxInstance.destroy();
      rellaxInstance = null;
    }
  });
})();

export default elementParallax;
