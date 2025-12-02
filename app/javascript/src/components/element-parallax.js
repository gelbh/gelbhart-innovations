/**
 * Element Parallax Component
 * @requires Rellax
 * Turbo-aware element parallax effect
 */

const elementParallax = (() => {
  let rellaxInstance = null;

  const initialize = () => {
    rellaxInstance?.destroy?.();
    rellaxInstance = null;

    if (!document.querySelector(".rellax")) return;

    rellaxInstance = new Rellax(".rellax", { horizontal: true });
  };

  const cleanup = () => {
    rellaxInstance?.destroy?.();
    rellaxInstance = null;
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default elementParallax;
