/**
 * Price switch
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const priceSwitch = (() => {
  function initialize() {
    const switcherWrappers = document.querySelectorAll(".price-switch-wrapper");

    if (switcherWrappers.length <= 0) return;

    for (let i = 0; i < switcherWrappers.length; i++) {
      const wrapper = switcherWrappers[i];
      const switcher = wrapper.querySelector('[data-bs-toggle="price"]');

      if (!switcher) continue;

      // Skip if already has listener attached
      if (switcher.dataset.priceSwitchAttached === "true") continue;

      switcher.addEventListener("change", (e) => {
        const checkbox = e.currentTarget.querySelector(
          'input[type="checkbox"]'
        );
        const monthlyPrice = e.currentTarget
          .closest(".price-switch-wrapper")
          .querySelectorAll("[data-monthly-price]");
        const annualPrice = e.currentTarget
          .closest(".price-switch-wrapper")
          .querySelectorAll("[data-annual-price]");

        for (let n = 0; n < monthlyPrice.length; n++) {
          if (checkbox.checked == true) {
            monthlyPrice[n].classList.add("d-none");
          } else {
            monthlyPrice[n].classList.remove("d-none");
          }
        }

        for (let m = 0; m < monthlyPrice.length; m++) {
          if (checkbox.checked == true) {
            annualPrice[m].classList.remove("d-none");
          } else {
            annualPrice[m].classList.add("d-none");
          }
        }
      });

      switcher.dataset.priceSwitchAttached = "true";
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default priceSwitch;
