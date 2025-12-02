/**
 * Cascading (Masonry) grid layout
 * Turbo-aware: works with both initial page load and Turbo navigation
 *
 * @requires https://github.com/desandro/imagesloaded
 * @requires https://github.com/Vestride/Shuffle
 */

const masonryGrid = (() => {
  // Store shuffle instances for cleanup
  const shuffleInstances = new Map();

  function initialize() {
    const grids = document.querySelectorAll(".masonry-grid");

    if (grids === null) return;

    for (let i = 0; i < grids.length; i++) {
      const grid = grids[i];

      // Skip if already initialized (check for existing instance)
      if (shuffleInstances.has(grid)) continue;

      /* eslint-disable no-undef */
      const masonry = new Shuffle(grid, {
        itemSelector: ".masonry-grid-item",
        sizer: ".masonry-grid-item",
      });

      shuffleInstances.set(grid, masonry);

      imagesLoaded(grid).on("progress", () => {
        masonry.layout();
      });
      /* eslint-enable no-undef */

      // Filtering
      const filtersWrap = grid.closest(".masonry-filterable");
      if (filtersWrap === null) continue;

      const filters = filtersWrap.querySelectorAll(
        ".masonry-filters [data-group]"
      );

      for (let n = 0; n < filters.length; n++) {
        // Skip if already has listener attached
        if (filters[n].dataset.filterAttached === "true") continue;

        filters[n].addEventListener("click", function (e) {
          const current = filtersWrap.querySelector(".masonry-filters .active");
          const target = this.dataset.group;

          if (current !== null) {
            current.classList.remove("active");
          }
          this.classList.add("active");
          masonry.filter(target);
          e.preventDefault();
        });

        filters[n].dataset.filterAttached = "true";
      }
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);

  // Cleanup before Turbo cache
  document.addEventListener("turbo:before-cache", () => {
    shuffleInstances.forEach((instance) => {
      if (instance && typeof instance.destroy === "function") {
        instance.destroy();
      }
    });
    shuffleInstances.clear();
  });
})();

export default masonryGrid;
