/**
 * Navigation Utilities
 * Handles scroll position management for smooth navigation
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const navigation = (() => {
  
  // Enable scroll restoration for back/forward navigation
  if ('scrollRestoration' in history) {
    history.scrollRestoration = 'auto';
  }

  // Track navigation type to determine scroll behavior
  let isBackForward = false;

  // Detect back/forward navigation via popstate
  window.addEventListener('popstate', () => {
    isBackForward = true;
  });

  // Track Turbo navigation start
  document.addEventListener('turbo:before-visit', (event) => {
    // Check if this is a back/forward navigation
    // Turbo sets detail.action to 'restore' for back/forward
    if (event.detail && event.detail.action === 'restore') {
      isBackForward = true;
    } else {
      isBackForward = false;
    }
  });

  // Handle scroll position after navigation
  document.addEventListener('turbo:load', () => {
    if (!isBackForward) {
      // Scroll to top on new navigation (with smooth behavior)
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    }
    // Reset flag for next navigation
    isBackForward = false;
  });

  // Also handle initial page load
  document.addEventListener('DOMContentLoaded', () => {
    // Ensure we're at the top on initial load
    window.scrollTo(0, 0);
  });

})();

export default navigation;

