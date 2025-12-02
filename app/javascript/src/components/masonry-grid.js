/**
 * Masonry Grid Component
 * @requires imagesLoaded
 * @requires Shuffle
 * Turbo-aware cascading grid layout
 */

const masonryGrid = (() => {
  const shuffleInstances = new Map();

  const initialize = () => {
    for (const grid of document.querySelectorAll(".masonry-grid")) {
      if (shuffleInstances.has(grid)) continue;

      const masonry = new Shuffle(grid, {
        itemSelector: ".masonry-grid-item",
        sizer: ".masonry-grid-item",
      });

      shuffleInstances.set(grid, masonry);
      imagesLoaded(grid).on("progress", () => masonry.layout());

      // Setup filtering
      const filtersWrap = grid.closest(".masonry-filterable");
      if (!filtersWrap) continue;

      for (const filter of filtersWrap.querySelectorAll(
        ".masonry-filters [data-group]"
      )) {
        if (filter.dataset.filterAttached === "true") continue;

        filter.addEventListener("click", function (e) {
          e.preventDefault();
          filtersWrap
            .querySelector(".masonry-filters .active")
            ?.classList.remove("active");
          this.classList.add("active");
          masonry.filter(this.dataset.group);
        });

        filter.dataset.filterAttached = "true";
      }
    }
  };

  const cleanup = () => {
    shuffleInstances.forEach((instance) => instance?.destroy?.());
    shuffleInstances.clear();
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default masonryGrid;
