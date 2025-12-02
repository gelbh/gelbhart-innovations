/**
 * Sticky Navbar Component
 * Turbo-aware sticky navigation bar
 */

const stickyNavbar = (() => {
  let scrollHandler = null;

  const initialize = () => {
    const navbar = document.querySelector(".navbar-sticky");
    if (!navbar) return;

    if (scrollHandler) window.removeEventListener("scroll", scrollHandler);

    const navbarHeight = navbar.offsetHeight;
    const scrollOffset = 500;
    const isAbsolute = navbar.classList.contains("position-absolute");

    scrollHandler = () => {
      const shouldStick = window.pageYOffset > scrollOffset;

      if (isAbsolute) {
        navbar.classList.toggle("navbar-stuck", shouldStick);
      } else {
        document.body.style.paddingTop = shouldStick ? `${navbarHeight}px` : "";
        navbar.classList.toggle("navbar-stuck", shouldStick);
      }
    };

    window.addEventListener("scroll", scrollHandler);
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default stickyNavbar;
