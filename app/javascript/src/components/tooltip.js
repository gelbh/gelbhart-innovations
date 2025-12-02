/**
 * Tooltip Component
 * @requires Bootstrap
 * Turbo-aware Bootstrap tooltips
 */

const tooltip = (() => {
  let instances = [];

  const initialize = () => {
    instances.forEach((t) => t?.dispose?.());
    instances = Array.from(
      document.querySelectorAll('[data-bs-toggle="tooltip"]')
    ).map((el) => new bootstrap.Tooltip(el, { trigger: "hover" }));
  };

  const cleanup = () => {
    instances.forEach((t) => t?.dispose?.());
    instances = [];
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default tooltip;
