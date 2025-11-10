/**
 * Animate scroll to top button in/off view
 * Turbo-aware: works with both initial page load and Turbo navigation
 * Also handles instant click-to-scroll (bypasses SmoothScroll for immediate response)
*/

const scrollTopButton = (() => {

  let scrollHandler = null;
  let clickHandler = null;

  function initialize() {
    let element = document.querySelector('.btn-scroll-top'),
        scrollOffset = 600;
    
    if (element == null) return;

    // Remove existing scroll handler if any
    if (scrollHandler) {
      window.removeEventListener('scroll', scrollHandler);
    }

    // Remove existing click handler if any
    if (clickHandler) {
      element.removeEventListener('click', clickHandler);
    }

    let offsetFromTop = parseInt(scrollOffset, 10);
    
    // Handle show/hide on scroll
    scrollHandler = (e) => {
      if (window.pageYOffset > offsetFromTop) {
        element.classList.add('show');
      } else {
        element.classList.remove('show');
      }
    };
    
    window.addEventListener('scroll', scrollHandler);

    // Handle instant scroll to top on click
    // This bypasses SmoothScroll for immediate response without delay
    clickHandler = (e) => {
      e.preventDefault();
      e.stopPropagation();
      
      // Instant smooth scroll using native browser API
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    };

    element.addEventListener('click', clickHandler);
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener('DOMContentLoaded', initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener('turbo:load', initialize);

})();

export default scrollTopButton;
