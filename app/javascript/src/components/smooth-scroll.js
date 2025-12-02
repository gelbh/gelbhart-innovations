/**
 * Smooth Scroll Component
 * @requires SmoothScroll
 * Turbo-aware anchor smooth scrolling
 */

const smoothScroll = (() => {
  const SELECTOR = "[data-scroll]";
  const HEADER_SELECTOR = "[data-scroll-header]";
  let scroll = null;

  const initialize = () => {
    if (typeof SmoothScroll === "undefined") {
      setTimeout(initialize, 50);
      return;
    }

    scroll?.destroy?.();

    scroll = new SmoothScroll(SELECTOR, {
      speed: 300,
      speedAsDuration: true,
      offset: (anchor, toggle) => toggle.dataset.scrollOffset || 40,
      header: HEADER_SELECTOR,
      updateURL: false,
      easing: "easeOutCubic",
    });
  };

  const initializeOnLoad = () => {
    if (document.readyState === "complete") {
      initialize();
    } else {
      window.addEventListener("load", initialize, { once: true });
    }
  };

  initializeOnLoad();
  document.addEventListener("turbo:load", () => setTimeout(initialize, 10));
})();

export default smoothScroll;
