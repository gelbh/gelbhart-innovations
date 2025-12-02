/**
 * Price Switch Component
 * Turbo-aware monthly/annual price toggle
 */

const priceSwitch = (() => {
  const initialize = () => {
    for (const wrapper of document.querySelectorAll(".price-switch-wrapper")) {
      const switcher = wrapper.querySelector('[data-bs-toggle="price"]');
      if (!switcher || switcher.dataset.priceSwitchAttached === "true")
        continue;

      switcher.addEventListener("change", (e) => {
        const isAnnual = e.currentTarget.querySelector(
          'input[type="checkbox"]'
        ).checked;
        const priceWrapper = e.currentTarget.closest(".price-switch-wrapper");

        for (const el of priceWrapper.querySelectorAll(
          "[data-monthly-price]"
        )) {
          el.classList.toggle("d-none", isAnnual);
        }
        for (const el of priceWrapper.querySelectorAll("[data-annual-price]")) {
          el.classList.toggle("d-none", !isAnnual);
        }
      });

      switcher.dataset.priceSwitchAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default priceSwitch;
