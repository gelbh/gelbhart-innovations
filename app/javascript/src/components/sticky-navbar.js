/**
 * Sticky Navbar
 * Enable sticky behavior of navigation bar on page scroll
 * Turbo-aware: works with both initial page load and Turbo navigation
*/

const stickyNavbar = (() => {
  
  let scrollHandler = null;

  function initialize() {
    let navbar = document.querySelector('.navbar-sticky');

    if (navbar == null) return;

    // Remove existing scroll handler if any
    if (scrollHandler) {
      window.removeEventListener('scroll', scrollHandler);
    }

    let navbarClass = navbar.classList,
        navbarH = navbar.offsetHeight,
        scrollOffset = 500;

    if (navbarClass.contains('position-absolute')) {
      scrollHandler = (e) => {
        if (window.pageYOffset > scrollOffset) {
          navbar.classList.add('navbar-stuck');
        } else {
          navbar.classList.remove('navbar-stuck');
        }
      };
      window.addEventListener('scroll', scrollHandler);
    } else {
      scrollHandler = (e) => {
        if (window.pageYOffset > scrollOffset) {
          document.body.style.paddingTop = navbarH + 'px';
          navbar.classList.add('navbar-stuck');
        } else {
          document.body.style.paddingTop = '';
          navbar.classList.remove('navbar-stuck');
        }
      };
      window.addEventListener('scroll', scrollHandler);
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener('DOMContentLoaded', initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener('turbo:load', initialize);

})();

export default stickyNavbar;
