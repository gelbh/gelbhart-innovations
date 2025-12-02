/**
 * Scroll Top Button Component
 * Turbo-aware back-to-top button
 */

const scrollTopButton = (() => {
  let scrollHandler = null;
  let clickHandler = null;

  const initialize = () => {
    const button = document.querySelector(".btn-scroll-top");
    if (!button) return;

    const scrollOffset = 600;

    // Remove existing handlers
    if (scrollHandler) window.removeEventListener("scroll", scrollHandler);
    if (clickHandler) button.removeEventListener("click", clickHandler);

    scrollHandler = () => {
      button.classList.toggle("show", window.pageYOffset > scrollOffset);
    };

    clickHandler = (e) => {
      e.preventDefault();
      e.stopPropagation();
      window.scrollTo({ top: 0, behavior: "smooth" });
    };

    window.addEventListener("scroll", scrollHandler);
    button.addEventListener("click", clickHandler);
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default scrollTopButton;
