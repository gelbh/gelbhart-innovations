/**
 * Navigation Utilities
 * Handles scroll position management for Turbo navigation
 */

const navigation = (() => {
  // Enable browser scroll restoration for back/forward navigation
  if ("scrollRestoration" in history) {
    history.scrollRestoration = "auto";
  }

  let isBackForward = false;

  // Detect back/forward navigation
  window.addEventListener("popstate", () => {
    isBackForward = true;
  });

  // Track Turbo navigation type
  document.addEventListener("turbo:before-visit", (event) => {
    isBackForward = event.detail?.action === "restore";
  });

  // Handle scroll position after navigation
  document.addEventListener("turbo:load", () => {
    if (!isBackForward) {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
    isBackForward = false;
  });

  // Scroll to top on initial page load
  document.addEventListener("DOMContentLoaded", () => {
    window.scrollTo(0, 0);
  });
})();

export default navigation;
