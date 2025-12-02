/**
 * Carousel Component
 * @requires Swiper
 * Turbo-aware content carousel with extensive options
 */

const carousel = (() => {
  const initialize = () => {
    for (const element of document.querySelectorAll(
      ".swiper:not(.swiper-initialized)"
    )) {
      const userOptions = element.dataset.swiperOptions
        ? JSON.parse(element.dataset.swiperOptions)
        : {};

      const pagerOptions = userOptions.pager
        ? {
            pagination: {
              el: ".pagination .list-unstyled",
              clickable: true,
              bulletActiveClass: "active",
              bulletClass: "page-item",
              renderBullet: (index, className) =>
                `<li class="${className}"><a href="#" class="page-link btn-icon btn-sm">${
                  index + 1
                }</a></li>`,
            },
          }
        : {};

      const swiper = new Swiper(element, { ...userOptions, ...pagerOptions });

      if (userOptions.tabs) {
        swiper.on("activeIndexChange", (e) => {
          const targetTab = document.querySelector(
            e.slides[e.activeIndex].dataset.swiperTab
          );
          const previousTab = document.querySelector(
            e.slides[e.previousIndex].dataset.swiperTab
          );

          previousTab?.classList.remove("active");
          targetTab?.classList.add("active");
        });
      }
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default carousel;
