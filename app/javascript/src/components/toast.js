/**
 * Toast Component
 * @requires Bootstrap
 * Turbo-aware Bootstrap toasts
 */

const toast = (() => {
  let instances = [];

  const initialize = () => {
    instances.forEach((t) => t?.dispose?.());
    instances = Array.from(document.querySelectorAll(".toast")).map(
      (el) => new bootstrap.Toast(el)
    );
  };

  const cleanup = () => {
    instances.forEach((t) => t?.dispose?.());
    instances = [];
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default toast;
