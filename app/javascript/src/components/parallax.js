/**
 * Mouse Parallax Component
 * @requires parallax-js
 * Turbo-aware mouse move parallax effect
 */

const parallax = (() => {
  let instances = [];

  const initialize = () => {
    instances.forEach((i) => i?.destroy?.());
    instances = [];

    for (const el of document.querySelectorAll(".parallax")) {
      instances.push(new Parallax(el));
    }
  };

  const cleanup = () => {
    instances.forEach((i) => i?.destroy?.());
    instances = [];
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default parallax;
