/**
 * Mouse move parallax effect
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/wagerfield/parallax
 */

const parallax = (() => {
  // Store parallax instances for cleanup
  let parallaxInstances = [];

  function initialize() {
    // Destroy existing instances to prevent duplicates
    parallaxInstances.forEach((instance) => {
      if (instance && typeof instance.destroy === "function") {
        instance.destroy();
      }
    });
    parallaxInstances = [];

    const elements = document.querySelectorAll(".parallax");

    for (let i = 0; i < elements.length; i++) {
      /* eslint-disable no-unused-vars, no-undef */
      const parallaxInstance = new Parallax(elements[i]);
      parallaxInstances.push(parallaxInstance);
      /* eslint-enable no-unused-vars, no-undef */
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache
  document.addEventListener("turbo:before-cache", () => {
    parallaxInstances.forEach((instance) => {
      if (instance && typeof instance.destroy === "function") {
        instance.destroy();
      }
    });
    parallaxInstances = [];
  });
})();

export default parallax;
