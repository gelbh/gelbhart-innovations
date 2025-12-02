/**
 * Page Loader Component
 * Turbo-aware loading indicator
 */

const pageLoader = (() => {
  const loader = document.getElementById("page-loader");
  if (!loader) return;

  const show = () => loader.classList.add("active");
  const hide = () => setTimeout(() => loader.classList.remove("active"), 100);

  document.addEventListener("turbo:before-visit", show);
  document.addEventListener("turbo:load", hide);
  document.addEventListener("turbo:frame-load", hide);
  document.addEventListener("DOMContentLoaded", hide);
})();

export default pageLoader;
