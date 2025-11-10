/**
 * Page Loader Component
 * Shows a loading indicator during Turbo navigation
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const pageLoader = (() => {
  let loader = document.getElementById('page-loader');
  
  if (loader == null) return;

  // Show loader when navigation starts
  document.addEventListener('turbo:before-visit', () => {
    loader.classList.add('active');
  });

  // Hide loader when navigation completes
  document.addEventListener('turbo:load', () => {
    // Small delay to ensure smooth transition
    setTimeout(() => {
      loader.classList.remove('active');
    }, 100);
  });

  // Also hide on initial page load
  document.addEventListener('DOMContentLoaded', () => {
    loader.classList.remove('active');
  });

  // Handle navigation errors
  document.addEventListener('turbo:frame-load', () => {
    loader.classList.remove('active');
  });

})();

export default pageLoader;

