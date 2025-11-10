/**
 * Animate scroll to top button in/off view
 * Turbo-aware: works with both initial page load and Turbo navigation
*/

const scrollTopButton = (() => {

  let scrollHandler = null;

  function initialize() {
    let element = document.querySelector('.btn-scroll-top'),
        scrollOffset = 600;
    
    if (element == null) return;

    // Remove existing scroll handler if any
    if (scrollHandler) {
      window.removeEventListener('scroll', scrollHandler);
    }

    let offsetFromTop = parseInt(scrollOffset, 10);
    
    scrollHandler = (e) => {
      if (window.pageYOffset > offsetFromTop) {
        element.classList.add('show');
      } else {
        element.classList.remove('show');
      }
    };
    
    window.addEventListener('scroll', scrollHandler);
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener('DOMContentLoaded', initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener('turbo:load', initialize);

})();

export default scrollTopButton;
