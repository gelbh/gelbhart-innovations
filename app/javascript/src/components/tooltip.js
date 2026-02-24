/**
 * Tooltip Component
 * @requires Bootstrap
 * Turbo-aware Bootstrap tooltips
 */

const tooltip = (() => {
  let instances = [];

  const safeDispose = (t) => {
    try {
      t?.dispose?.();
    } catch (_) {
      // dispose() can throw if element was removed (e.g. Turbo cache)
    }
  };

  const initialize = () => {
    instances.forEach(safeDispose);
    instances = [];
    instances = Array.from(
      document.querySelectorAll('[data-bs-toggle="tooltip"]')
    ).map((el) => new bootstrap.Tooltip(el, { trigger: "hover" }));
  };

  const cleanup = () => {
    instances.forEach(safeDispose);
    instances = [];
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default tooltip;
