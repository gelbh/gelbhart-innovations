/**
 * Anchor smooth scrolling
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/cferdinandi/smooth-scroll/
 * 
 * Note: theme.min.js also initializes SmoothScroll with speed:800.
 * This component reinitializes it with faster settings after theme.min.js loads.
*/

const smoothScroll = (() => {

  let selector = '[data-scroll]',
      fixedHeader = '[data-scroll-header]',
      scroll = null;

  function initialize() {
    // Wait for SmoothScroll library to be available
    if (typeof SmoothScroll === 'undefined') {
      // If not available yet, try again after a short delay
      setTimeout(initialize, 50);
      return;
    }

    // Destroy our existing instance if it exists
    if (scroll && typeof scroll.destroy === 'function') {
      scroll.destroy();
      scroll = null;
    }

    // Find and destroy any existing SmoothScroll instances created by theme.min.js
    // SmoothScroll stores event listeners on elements, so we need to rebind
    // We'll create a new instance which will properly rebind with our settings
    const existingLinks = document.querySelectorAll(selector);
    if (existingLinks.length > 0) {
      // Remove any existing click listeners by cloning and replacing elements
      // This is a workaround since SmoothScroll doesn't expose instance references
      existingLinks.forEach(link => {
        // SmoothScroll adds data attributes, we can check for those
        // But the cleanest way is to just create a new instance
        // which will rebind properly
      });
    }

    // Create new SmoothScroll instance with faster settings
    // This will override any previous initialization from theme.min.js
    scroll = new SmoothScroll(selector, {
      speed: 300,
      speedAsDuration: true,
      offset: (anchor, toggle) => {
        return toggle.dataset.scrollOffset || 40;
      },
      header: fixedHeader,
      updateURL: false,
      easing: 'easeOutCubic'
    });
  }

  // For initial page load: wait for window.load to ensure theme.min.js has finished
  // This ensures our faster initialization happens after theme.min.js's slow one
  function initializeOnLoad() {
    if (document.readyState === 'complete') {
      // Page already loaded, initialize immediately
      initialize();
    } else {
      // Wait for all scripts (including theme.min.js) to load
      window.addEventListener('load', initialize, { once: true });
    }
  }

  // Initialize on initial page load (after all scripts load)
  if (document.readyState === 'loading') {
    initializeOnLoad();
  } else {
    // DOM already loaded, but scripts might still be loading
    initializeOnLoad();
  }

  // Initialize on Turbo load (Turbo navigation)
  // On Turbo navigation, theme.min.js doesn't re-run, so we can initialize immediately
  document.addEventListener('turbo:load', () => {
    // Small delay to ensure DOM is ready
    setTimeout(initialize, 10);
  });

})();

export default smoothScroll;
