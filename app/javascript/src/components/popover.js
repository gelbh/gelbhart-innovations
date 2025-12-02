/**
 * Popover Component
 * @requires Bootstrap
 * Turbo-aware Bootstrap popovers
 */

const popover = (() => {
  let instances = [];

  const initialize = () => {
    instances.forEach((p) => p?.dispose?.());
    instances = Array.from(
      document.querySelectorAll('[data-bs-toggle="popover"]')
    ).map((el) => new bootstrap.Popover(el));
  };

  const cleanup = () => {
    instances.forEach((p) => p?.dispose?.());
    instances = [];
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default popover;
