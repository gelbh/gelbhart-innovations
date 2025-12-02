/**
 * View Transitions API Integration with Turbo Drive
 *
 * Provides smooth morphing page transitions in browsers that support the View Transitions API
 * (Chrome 111+, Edge 111+) and graceful fallback to CSS fade animations for other browsers.
 *
 * @requires Turbo Drive
 */

/**
 * Check if the browser supports the View Transitions API
 * @returns {boolean} True if View Transitions API is supported
 */
const supportsViewTransitions = () => {
  return typeof document.startViewTransition === "function";
};

/**
 * Initialize View Transitions for Turbo navigation
 * Intercepts Turbo's rendering process to apply smooth transitions
 */
const initViewTransitions = () => {
  // Only intercept if View Transitions API is supported
  if (!supportsViewTransitions()) {
    console.log("View Transitions API not supported, using CSS fallback");
    return;
  }

  // Intercept Turbo's before-render event to apply View Transitions
  document.addEventListener("turbo:before-render", (event) => {
    event.preventDefault();

    // Start a view transition
    document.startViewTransition(() => {
      // Resume Turbo's rendering process within the transition
      event.detail.resume();
    });
  });

  console.log("View Transitions API enabled for Turbo navigation");
};

/**
 * Add CSS fallback class for browsers without View Transitions API
 * This enables CSS-based fade transitions as a fallback
 */
const initFallbackTransitions = () => {
  if (supportsViewTransitions()) {
    return;
  }

  // Add loading class during Turbo navigation for CSS fade effect
  document.addEventListener("turbo:before-render", () => {
    document.documentElement.classList.add("turbo-loading");
  });

  document.addEventListener("turbo:render", () => {
    // Use requestAnimationFrame to ensure the transition is visible
    requestAnimationFrame(() => {
      document.documentElement.classList.remove("turbo-loading");
    });
  });
};

// Initialize on DOM ready
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => {
    initViewTransitions();
    initFallbackTransitions();
  });
} else {
  // DOM already loaded
  initViewTransitions();
  initFallbackTransitions();
}
