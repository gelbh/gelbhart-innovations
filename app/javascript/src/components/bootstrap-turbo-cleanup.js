/**
 * Keeps Bootstrap dropdowns working with Turbo Drive: disposes before cache,
 * re-initializes after each render so dropdowns work after navigation and
 * restore-from-cache (when toggles are new DOM nodes).
 */

const DROPDOWN_SELECTOR = "[data-bs-toggle=\"dropdown\"]";

function getBootstrapDropdown() {
  return typeof bootstrap !== "undefined" ? bootstrap.Dropdown : null;
}

function disposeDropdowns() {
  const Dropdown = getBootstrapDropdown();
  if (!Dropdown) return;

  document.querySelectorAll(DROPDOWN_SELECTOR).forEach((el) => {
    try {
      const instance = Dropdown.getInstance(el);
      if (instance) instance.dispose();
    } catch {
      // Element detached or dispose threw
    }
  });
}

function initDropdowns() {
  const Dropdown = getBootstrapDropdown();
  if (!Dropdown) return;

  document.querySelectorAll(DROPDOWN_SELECTOR).forEach((el) => {
    try {
      if (!Dropdown.getInstance(el)) {
        new Dropdown(el);
      }
    } catch {
      // Element not in DOM or init failed
    }
  });
}

function onRender() {
  requestAnimationFrame(initDropdowns);
}

document.addEventListener("turbo:before-cache", disposeDropdowns);
document.addEventListener("turbo:load", onRender);
document.addEventListener("turbo:render", onRender);

export default Object.freeze({ disposeDropdowns, initDropdowns });
